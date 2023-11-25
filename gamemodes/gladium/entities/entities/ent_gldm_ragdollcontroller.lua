AddCSLuaFile()
ENT.Type   = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Ragdoll")
end

local function find_bone(ent,name)
	local bone = ent:LookupBone(name)
	if bone then
		return ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(bone))
	end
end

local function find_footid(ent,side)
	local name = "ValveBiped.Bip01_R_Foot"
	if(side==1)then
		name = "ValveBiped.Bip01_L_Foot"
	end
	
	local bone = ent:LookupBone(name)
	if bone then
		return ent:TranslateBoneToPhysBone(bone)
	end
end

local shadow_data = {
	secondstoarrive = .0001,
	
	maxangular = 800,
	maxangulardamp = 10000,
	
	maxspeed = 400,
	maxspeeddamp = 10000,

	dampfactor = .8,

	teleportdistance = 1000
}

local function doControl(phys,pos,ang)

	shadow_data.pos = pos
	shadow_data.angle = ang

	--local abnormal = false

	--if !ang or !pos then
	if(!ang)then
		shadow_data.maxangular = 0
	end
	if(!pos)then
		shadow_data.maxspeed = 0
	end		
	phys:ComputeShadowControl(shadow_data)
	if(!ang)then
		shadow_data.maxangular = 800
	end
	if(!pos)then
		shadow_data.maxspeed = 400
	end		
	--abnormal=true
	--end

end

function ENT:Initialize()
	--self:SetModel("error.mdl")

	local ragdoll = self:GetRagdoll()

	if(SERVER)then
		self:DeleteOnRemove(ragdoll)
	end

	self:StartMotionController()
	self:AddToMotionController(ragdoll:GetPhysicsObject())
	

	self:SetParent(ragdoll)
	self:SetLocalPos(Vector())

	self:DrawShadow(false)
	
	
	self.PhysBones={
		pelvis = find_bone(ragdoll,"ValveBiped.Bip01_Pelvis"),
		spine2 = find_bone(ragdoll,"ValveBiped.Bip01_Spine2"),
		head = find_bone(ragdoll,"ValveBiped.Bip01_Head1"),
		
		footl = find_bone(ragdoll,"ValveBiped.Bip01_L_Foot"),
		footr = find_bone(ragdoll,"ValveBiped.Bip01_R_Foot"),
		
		handl = find_bone(ragdoll,"ValveBiped.Bip01_L_Hand"),
		handr = find_bone(ragdoll,"ValveBiped.Bip01_R_Hand"),		
	}
	
	self.Step={}
end

function ENT:Think()
	if(SERVER)then
		local ragdoll = self:GetRagdoll()
		ragdoll:PhysWake()
	end
end

function ENT:PhysicsSimulate(phys,dt)
	if(!IsValid(self:GetOwner()))then
		self:Remove()
		return
	end

	local ply = self:GetOwner()

	ply:SetPos(self:GetPos())
	local ragdoll = self:GetRagdoll()
	
	shadow_data.deltatime = dt
	
	local head = self.PhysBones.head
	local spine2 = self.PhysBones.spine2
	local pelvis = self.PhysBones.pelvis

	local downtrace = {start = pelvis:GetPos(), endpos = pelvis:GetPos()+Vector(0,0,-40), filter=ragdoll}
	local trace = util.TraceLine(downtrace)
	
	if(trace.Hit)then
		--Angle(0,ply:EyeAngles()[2],0)
		local footbase = self:GetFootBase(ragdoll)
		
		footbase=footbase+Vector(0,0,30)
		
		local eyeangs = ply:EyeAngles()
		doControl(pelvis,footbase+Vector(0,0,0))
		shadow_data.maxangular = 400
		doControl(spine2,footbase+Vector(0,0,10),Angle(-90,-90+eyeangs[2],0))
		doControl(head,footbase+Vector(0,0,42),Angle(-90,90+eyeangs[2],0))
		shadow_data.maxangular = 800
	end
	--pelvis:ComputeShadowControl(shadow_data)
	
	self:StepThink(ply,ragdoll)
	
end

function ENT:GetFootBase(ragdoll)
	local footr,footl = self.PhysBones.footr,self.PhysBones.footl
	local foot_base = (footr:GetPos()+footl:GetPos())/2
	foot_base.z = math.min(footl:GetPos().z,footr:GetPos().z)
	return foot_base
end

function ENT:StepStart(side,goal,time,height)
	local bone = self:GetFootBone(side)

	self.Step = {
		side = side,
		start= bone:GetPos(),
		goal= goal,
		starttime = time,
		time = time,
		height = height
	}

	--self.step_wait = false
end

function ENT:GetFootBone(side)
	local footr,footl = self.PhysBones.footr,self.PhysBones.footl
	local foot = footr
	if(side==1)then
		foot = footl
	end
	return foot
end

function ENT:GetFootTrace(side,deep)
	local ragdoll = self:GetRagdoll()
	local footr,footl = self.PhysBones.footr,self.PhysBones.footl
	local foot = footr
	if(side==1)then
		foot = footl
	end
	local base_pos = foot:GetPos() + Vector(0,0,10)
	local downtrace = {start = base_pos, endpos = base_pos+Vector(0,0,deep or -80), filter=ragdoll}
	local trace = util.TraceLine(downtrace)	

	return trace
end

function ENT:GetStepPos(side)
	local ragdoll = self:GetRagdoll()
	local eyeangs = self:GetOwner():EyeAngles()

	local foot = self:GetFootBone(side)
	
	local yaw = Angle(0,eyeangs[2],0)
	
	local offset = 8
	if(side==1)then
		offset = -offset
	end
	
	local foot_offset = yaw:Forward()*25+yaw:Right()*offset
	
	local base_pos = ragdoll:GetPhysicsObject():GetPos() + foot_offset
	local downtrace = {start = base_pos, endpos = base_pos+Vector(0,0,-80), filter=ragdoll}
	local trace = util.TraceLine(downtrace)	
	
	return trace
end

function ENT:StepThink(ply,ragdoll)
	if(!self.Step)then return end
	local step = self.Step
	local footr,footl = self.PhysBones.footr,self.PhysBones.footl
	--local eyeangs = ply:EyeAngles()
	
	if(ply:KeyPressed(IN_FORWARD))then
		--local pelvis = self.PhysBones.pelvis
		
		local trace = self:GetStepPos(1)
		
		if(trace.Hit)then
			self:StepStart(1,trace.HitPos,0.3,5)
		end
	end
	
	if(ply:KeyDown(IN_FORWARD))then
		if(step.time and step.time>0)then
			step.time=step.time-FrameTime()
			local foot = self:GetFootBone(step.side)
			
			local fraction = 1-(step.time/step.starttime)
			local exp_pos = LerpVector(fraction,step.start,step.goal)
			exp_pos.z = exp_pos.z + math.sin(fraction*math.pi)*step.height
			
			shadow_data.maxspeed = 800
			doControl(foot,exp_pos)
			shadow_data.maxspeed = 400
		else
			if(step.side==1)then
				step.side=0
			else
				step.side=1
			end

--[[
			local weldtrace = self:GetFootTrace(step.side,-15)
			if(weldtrace.Hit)then
				local id = find_footid(ragdoll,step.side)
				constraint.Weld( ragdoll, weldtrace.Entity, id2, weldtrace.PhysicsBone, 250)
			end]]

			local trace = self:GetStepPos(step.side)
			if(trace.Hit)then
				self:StepStart(step.side,trace.HitPos,0.3,5)
			end
		end
	end
end