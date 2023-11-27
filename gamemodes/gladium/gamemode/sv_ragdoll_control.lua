--Машинеры будут связаны с Масонами
if(SERVER)then
	util.AddNetworkString("BSF_RAGDOLLCONTROL(AssignRagdoll)")
	util.AddNetworkString("BSF_RAGDOLLCONTROL(AttackAngle)")
end

BSF_RAGDOLLCONTROL = BSF_RAGDOLLCONTROL or {}

include("sv_phys_control.lua")
include("sv_ragdoll_animation.lua")

include("sh_ragdoll_weapons.lua")	--SHARED FILE!
include("sv_ragdoll_weapons.lua")

function BSF_RAGDOLLCONTROL:KillRagdoll(rag,nokill)
	if(IsValid(rag))then
		if(!nokill and IsValid(rag:GetOwner()) and rag:GetOwner():Alive())then
			rag:GetOwner():Kill()
		end
		BSF_RAGDOLLCONTROL_WEAPONS:StripWeapons(rag)
		if(IsValid(rag:GetOwner()))then
			BSF_RAGDOLLCONTROL:RemoveSpectatingPoint(rag:GetOwner())
		end
		rag:Remove()
	end
end

function BSF_RAGDOLLCONTROL:KillPlayerRagdoll(ply,nokill)
	BSF_RAGDOLLCONTROL:KillRagdoll(ply.BSF_Ragdoll,nokill)
end

function BSF_RAGDOLLCONTROL:KillPlayer(ply)
	if(ply:Alive())then
		ply:Kill()
	end
end

function BSF_RAGDOLLCONTROL:FindBone(ent,name)
	local bone = ent:LookupBone(name)
	if bone then
		return ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(bone)),ent:TranslateBoneToPhysBone(bone)
	end
	return nil
end

_BSF_RAGDOLLCONTROL_default_shadow_data = {
	--secondstoarrive = .0001,
	
	maxangular = 800,
	maxangulardamp = 10000,
	
	maxspeed = 1800,
	maxspeeddamp = 10000,

	dampfactor = .8,

	teleportdistance = 0
}
_BSF_RAGDOLLCONTROL_shadow_data = table.Copy(_BSF_RAGDOLLCONTROL_default_shadow_data)

//ShadowControl

function BSF_RAGDOLLCONTROL:UpdateDeltaTime(phys,name)	--Optimize if needed
	local rag = phys:GetEntity()
	if(!rag._PhysToBones)then
		BSF_RAGDOLLCONTROL:SetupBones(rag)
	end
	local bone = rag._PhysToBones[phys]
	if(!bone)then
		bone = "root"
	end
	rag.LastRagdollMovements = rag.LastRagdollMovements or {}
	_BSF_RAGDOLLCONTROL_shadow_data.deltatime = CurTime()-(rag.LastRagdollMovements[bone] or CurTime())
	rag.LastRagdollMovements[bone] = CurTime()
end

function BSF_RAGDOLLCONTROL:ControllPhysBone(phys,pos,ang)
	BSF_RAGDOLLCONTROL:UpdateDeltaTime(phys)

	_BSF_RAGDOLLCONTROL_shadow_data.pos = pos
	_BSF_RAGDOLLCONTROL_shadow_data.angle = ang
	if(!ang)then
		_BSF_RAGDOLLCONTROL_shadow_data.maxangular = 0
		_BSF_RAGDOLLCONTROL_shadow_data.maxangulardamp = 0
	end
	if(!pos)then
		_BSF_RAGDOLLCONTROL_shadow_data.maxspeed = 0
		_BSF_RAGDOLLCONTROL_shadow_data.maxspeeddamp = 0
	end
	phys:Wake()
	phys:ComputeShadowControl(_BSF_RAGDOLLCONTROL_shadow_data)
	if(!ang)then
		_BSF_RAGDOLLCONTROL_shadow_data.maxangular = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangular
		_BSF_RAGDOLLCONTROL_shadow_data.maxangulardamp = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangulardamp
	end
	if(!pos)then
		_BSF_RAGDOLLCONTROL_shadow_data.maxspeed = _BSF_RAGDOLLCONTROL_default_shadow_data.maxspeed
		_BSF_RAGDOLLCONTROL_shadow_data.maxspeeddamp = _BSF_RAGDOLLCONTROL_default_shadow_data.maxspeeddamp
		--_BSF_RAGDOLLCONTROL_shadow_data.maxspeed = .8
	end
end

function BSF_RAGDOLLCONTROL:ControllPhysBoneAngleOffset(phys,physparent,ang)
	local curang = Angle(ang)
	local defaultangs = physparent:GetAngles()
	curang:RotateAroundAxis(defaultangs:Forward(),ang.p)
	curang:RotateAroundAxis(defaultangs:Right(),ang.y)
	curang:RotateAroundAxis(defaultangs:Up(),ang.r)
	BSF_RAGDOLLCONTROL:ControllPhysBone(phys,nil,curang)
end

//Foot Calculations
local _pelvis_flyadd = 10

function BSF_RAGDOLLCONTROL:GetFootBase(rag)
	--[[
	local b_footl = rag.PhysBones["ValveBiped.Bip01_L_Foot"]
	local b_footr = rag.PhysBones["ValveBiped.Bip01_R_Foot"]
	
	local flpos = b_footl:GetPos()
	local frpos = b_footr:GetPos()

	local base = (flpos+frpos)/2
	base.z = math.min(flpos.z,frpos.z)
	]]
	
	local b_pelvis = rag.PhysBones["ValveBiped.Bip01_Pelvis"]
	local downtrace = {start = b_pelvis:GetPos(), endpos = b_pelvis:GetPos()+vector_up*-(40+_pelvis_flyadd), filter=rag}
	local trace = util.TraceLine(downtrace)
	local base = trace.HitPos
	base.z = math.max(base.z,b_pelvis:GetPos().z-29-_pelvis_flyadd)
	
	--print(rag)
	return base

--[[
	local base_pos = foot:GetPos() + Vector(0,0,10)
	local downtrace = {start = base_pos, endpos = base_pos+Vector(0,0,-80), filter=ragdoll}
	local trace = util.TraceLine(downtrace)
]]
end

//Bone Setup

function BSF_RAGDOLLCONTROL:SetupBones(rag)
	rag.PhysBones = {}
	rag._PhysToBones = {}
	rag._PhysToBonesNum = {}
	
	rag._PhysToBonesByVolume = {}	--Fucking fun
	for i = 0, rag:GetBoneCount() - 1 do
		local bone = BSF_RAGDOLLCONTROL:FindBone(rag,rag:GetBoneName( i ))
		if(bone)then
			local id = nil
			rag.PhysBones[rag:GetBoneName( i )],id = BSF_RAGDOLLCONTROL:FindBone(rag,rag:GetBoneName( i ))
			rag._PhysToBones[rag.PhysBones[rag:GetBoneName( i )]] = rag:GetBoneName( i )
			rag._PhysToBonesNum[rag.PhysBones[rag:GetBoneName( i )]] = id
			rag._PhysToBonesByVolume[rag.PhysBones[rag:GetBoneName( i )]:GetVolume()] = rag:GetBoneName( i )
		end
    end
end

function BSF_RAGDOLLCONTROL:GetBoneNameFromPhysObj(phys)	--FUCK
	local rag = phys:GetEntity()
	return rag._PhysToBones[phys] or rag._PhysToBonesByVolume[phys:GetVolume()]
end

function BSF_RAGDOLLCONTROL:TrySetupBones(rag)
	if(!rag.PhysBones)then
		BSF_RAGDOLLCONTROL:SetupBones(rag)
	end
end

//Spectate

function BSF_RAGDOLLCONTROL:SpectateRagdoll(ply,rag)
	--ply:Spectate( OBS_MODE_CHASE )
	--ply:SpectateEntity( rag )
	ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	ply:SetRenderMode(RENDERMODE_NONE)
	ply:SetMoveType(MOVETYPE_NOCLIP)
	BSF_RAGDOLLCONTROL:CreateSpectatingPoint(ply)
	--ply:SetViewEntity(rag)
end

//Don't use. DEPRECATED
function BSF_RAGDOLLCONTROL:CreateSpectatingPoint(ply)
	local rag = ply.BSF_Ragdoll
	if(IsValid(rag._ViewEntity))then
		rag._ViewEntity:Remove()
	end
	rag._ViewEntity = ents.Create("ent_bsf_viewentity")
	--rag._ViewEntity:SetParent(rag,rag:LookupAttachment("eyes"))
	ply:SetViewEntity(rag._ViewEntity)
	--print(ply:GetViewEntity())
end

function BSF_RAGDOLLCONTROL:RemoveSpectatingPoint(ply)
	local rag = ply.BSF_Ragdoll
	if(IsValid(rag._ViewEntity))then
		rag._ViewEntity:Remove()
		ply:SetViewEntity(ply)
	end
end

function BSF_RAGDOLLCONTROL:UpdateViewEntPos(ply)
	local rag = ply.BSF_Ragdoll
	if(IsValid(rag._ViewEntity))then
		local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
		local bonepos = rag:GetBonePosition(bone)
		rag._ViewEntity:SetPos(bonepos)
	end
end

function BSF_RAGDOLLCONTROL:SpectatePointThinkAll()	--Optimize if needed
	for _,ply in pairs(player.GetAll())do
		local rag = ply.BSF_Ragdoll
		if(IsValid(rag))then
			if(IsChanged(IsValid(rag._ViewEntity),"BSF_ViewEntity",rag))then
				if(!IsValid(rag._ViewEntity))then
					ply:SetViewEntity(ply)
				--else
					--
				end
			end
			
			if(IsValid(rag._ViewEntity))then
				--rag._ViewEntity:SetPos()
				BSF_RAGDOLLCONTROL:UpdateViewEntPos(ply)
			end
			
			--local bone = rag:LookupBone("ValveBiped.Bip01_Pelvis")
			--local bonepos = rag:GetBonePosition(bone)
			ply:SetPos(rag:GetPos())
			local phys = ply:GetPhysicsObject()
			if(IsValid(phys))then
				phys:SetVelocity(vector_origin)
			end
		end
	end
end
hook.Add("Think","BSF_SpectatingPoint",BSF_RAGDOLLCONTROL.SpectatePointThinkAll)

//Ragdoll Setup

function BSF_RAGDOLLCONTROL:AssignRagdoll(rag,ply)
	ply.BSF_Ragdoll = rag
	--ply:SetNWEntity("BSF_Ragdoll",rag)
	
	net.Start("BSF_RAGDOLLCONTROL(AssignRagdoll)")
		net.WriteEntity(rag)
	net.Send(ply)
	
end

function BSF_RAGDOLLCONTROL:SetupRagdollHealth(rag,ply)
	rag:SetNWFloat("BSF_Health",100)
	rag:SetNWFloat("BSF_MaxHealth",100)
end

function BSF_RAGDOLLCONTROL:SetupRagdoll(rag,ply)
	rag.BSFRAG = true
	rag.BSF_CreationTime = CurTime()
	BSF_RAGDOLLCONTROL:AssignRagdoll(rag,ply)
	BSF_RAGDOLLCONTROL:TrySetupBones(rag)
	BSF_RAGDOLLCONTROL:SetupRagdollHealth(rag,ply)
	rag._DisallowedToMove = 10
	
	BSF_PHYSCONTROL:AddPhysCollideCallBack(rag)
	hook.Add("Think",rag,BSF_RAGDOLLCONTROL.RagdollThink)
end

function BSF_RAGDOLLCONTROL:IsRagdollJustCreated(rag)
	return rag.BSF_CreationTime == CurTime()
end

//Damage Hook

function BSF_RAGDOLLCONTROL:ApplyDamage(rag,dmg,phys,wep)
	BSF_RAGDOLLCONTROL:TrySetupBones(phys:GetEntity())
	if( !hook.Run("BSF_RAGDOLLCONTROL(Pre_ApplyDamage)",rag,dmg,phys,wep) )then
		local hitbone = BSF_RAGDOLLCONTROL:GetBoneNameFromPhysObj(phys)
		if(hitbone=="ValveBiped.Bip01_Head1" or hitbone=="ValveBiped.forward")then
			dmg:SetDamage(dmg:GetDamage()*2)
		end
		rag:TakeDamageInfo(dmg)
		hook.Run("BSF_RAGDOLLCONTROL(ApplyDamage)",rag,dmg,phys,wep,hitbone)
	end
end

function BSF_RAGDOLLCONTROL:ProcessRagdollDamage(rag,dmg)
	if(dmg:IsDamageType(DMG_CRUSH))then	--No bit.band here
		if(rag.BSF_Flying)then
			
		else
			dmg:SetDamage(0)
		end
	end
end

hook.Add("PostEntityTakeDamage","BSF_RAGDOLLCONTROL",function(rag,dmg,took)
	if(rag.BSFRAG and took)then
		BSF_RAGDOLLCONTROL:ProcessRagdollDamage(rag,dmg)
		--[[
		rag:SetNWFloat("BSF_Health",rag:GetNWFloat("BSF_Health")-dmg:GetDamage())
		if(rag:GetNWFloat("BSF_Health")<=0)then
			BSF_RAGDOLLCONTROL:KillPlayer(rag:GetOwner())
		end
		]]
		rag:GetOwner():TakeDamageInfo(dmg)
	end
end)

//Check Functions

function BSF_RAGDOLLCONTROL:GetKeyDown(ply,key)
	if(ply:GetInfoNum("bsf_autoattacks",0)==1)then
		return ply:KeyDown(key)
	else
		return ply:KeyPressed(key)
	end
end

function BSF_RAGDOLLCONTROL:CanMove(rag)
	if(IsValid(rag:GetOwner()))then
		if(!rag:GetOwner():Alive())then
			return false
		end
	else
		return false
	end
	return true
end

function BSF_RAGDOLLCONTROL:CanStand(rag)
	local b_footl = rag.PhysBones["ValveBiped.Bip01_L_Foot"]
	local b_footr = rag.PhysBones["ValveBiped.Bip01_R_Foot"]
	
	local downtrace = {start = b_footl:GetPos()+vector_up*2, endpos = b_footl:GetPos()+vector_up*-(8+_pelvis_flyadd), filter=rag}
	local trace = util.TraceLine(downtrace)	
	if(trace.Hit)then
		return trace.Fraction
	end
	local downtrace = {start = b_footr:GetPos()+vector_up*2, endpos = b_footr:GetPos()+vector_up*-(8+_pelvis_flyadd), filter=rag}
	local trace = util.TraceLine(downtrace)	
	if(trace.Hit)then
		return trace.Fraction
	end
	
	return false
end

//Movement think

BSF_RAGDOLLCONTROL.RagdollThink = function(rag)
	hook.Run("BSF(Pre_RagdollThink)",rag)
	BSF_RAGDOLLCONTROL:TrySetupBones(rag)
	BSF_RAGDOLLCONTROL:RagdollMovement(rag)
	hook.Run("BSF(RagdollThink)",rag)
end

local function _unNormalizeAngle(ang)
	if(ang<0)then
		ang = 180 +(180+ang)
	end
	return ang
end


function BSF_RAGDOLLCONTROL:CalcAttackAngle(ply,x,y,mw)
	ply._BSF_AttackAngle = ply._BSF_AttackAngle or 0
	ply._BSF_AttackSUM = ply._BSF_AttackSUM or 0
	ply._BSF_AttackMouseWheel = mw
	
	--print(ply:GetInfoNum("bsf_attackdirtolerance",15))
	if(math.abs(x)>ply:GetInfoNum("bsf_attackdirtolerance",15) or math.abs(y)>ply:GetInfoNum("bsf_attackdirtolerance",15))then
		local sum = math.abs(x)+math.abs(y)
		x = x/sum
		y = -y/sum
		
		if(x!=0 or y!=0) and sum!=0 then
			local ax = math.acos(x)
			local ay = math.asin(y)
			local ang = 0
			if(y>0)then
				ang = math.deg(ax)
			else
				ang = -math.deg(ax)
			end
			if(ply:GetInfoNum("bsf_attackdirinvert",0)==1)then
				ang = ang + 180
			end
			local goodang = _unNormalizeAngle(ang)
			--ply._BSF_AttackAngle = goodang
			ply._BSF_AttackAngle = math.ApproachAngle(_unNormalizeAngle(ply._BSF_AttackAngle),goodang,sum/ply._BSF_AttackSUM*10)
			ply._BSF_AttackAngle = math.NormalizeAngle(ply._BSF_AttackAngle)
			ply._BSF_AttackSUM = sum
		end
	end
end
hook.Add("StartCommand","BSF_RAGDOLLCONTROL",function(ply,cmd)
	BSF_RAGDOLLCONTROL:CalcAttackAngle(ply,cmd:GetMouseX(),cmd:GetMouseY(),cmd:GetMouseWheel())
end)

function BSF_RAGDOLLCONTROL:GetAttackAngle(ply)
	ply._BSF_AttackAngle = ply._BSF_AttackAngle or 0
	ply._BSF_AttackMouseWheel = ply._BSF_AttackMouseWheel or 0
	return ply._BSF_AttackAngle,ply._BSF_AttackMouseWheel
end

local function _ClampAngle(ang,min,max)
	ang.p = math.Clamp(ang.p,min,max)
	ang.y = math.Clamp(ang.y,min,max)
	ang.r = math.Clamp(ang.r,min,max)
end

function BSF_RAGDOLLCONTROL:GetAimAngleChange(ply)
	ply.BSF_AimAngle = ply.BSF_AimAngle or ply:EyeAngles()
	local change = ply:EyeAngles() - ply.BSF_AimAngle
	ply.BSF_AimAngle = ply:EyeAngles()
	change = change * 1
	change:Normalize()
	_ClampAngle(change,-25,25)
	
	ply.BSF_LastAimAngleChangeTime = ply.BSF_LastAimAngleChangeTime or 0
	if(ply.BSF_LastAimAngleChangeTime==CurTime())then
		ply.BSF_LastAimAngleChange = ply.BSF_LastAimAngleChange or change
		local change = ply.BSF_LastAimAngleChange
		ply.BSF_LastAimAngleChange = change
		ply.BSF_LastAimAngleChangeTime = CurTime()
		return change
	elseif(CurTime()-ply.BSF_LastAimAngleChangeTime>=engine.TickInterval()*2)then
		ply.BSF_LastAimAngleChange = change
		ply.BSF_LastAimAngleChangeTime = CurTime()
		return angle_zero
	end
	ply.BSF_LastAimAngleChange = change
	ply.BSF_LastAimAngleChangeTime = CurTime()
	
	return change
end

function BSF_RAGDOLLCONTROL:GetAimAngleChangeCorrected(ply,exp)
	local change = BSF_RAGDOLLCONTROL:GetAimAngleChange(ply)
	--print(change.p,change.p^0.9)
	if(change.p<0)then
		change.p = -(math.abs(change.p)^exp)
	else
		change.p = change.p^exp
	end
	if(change.y<0)then
		change.y = -(math.abs(change.y)^exp)
	else
		change.y = change.y^exp
	end
	if(change.r<0)then
		change.r = -(math.abs(change.r)^exp)
	else
		change.r = change.r^exp
	end
	
	return change
end

function BSF_RAGDOLLCONTROL:SendAttackAngle(ply,time)
	net.Start("BSF_RAGDOLLCONTROL(AttackAngle)")
		net.WriteInt(math.Round(BSF_RAGDOLLCONTROL:GetAttackAngle(ply)),9)
		net.WriteUInt(time,4)
	net.Send(ply)
end

function BSF_RAGDOLLCONTROL:IsAttackAngleIn(ply,min,max)
	return (BSF_RAGDOLLCONTROL:GetAttackAngle(ply)>=min and BSF_RAGDOLLCONTROL:GetAttackAngle(ply)<=max)
end

function BSF_RAGDOLLCONTROL:RagdollMovement(rag)
	if(rag._DisallowedToMove)then
		rag._DisallowedToMove = rag._DisallowedToMove -1
		if(rag._DisallowedToMove<1)then
			rag._DisallowedToMove=nil
		end
		return 
	end
	local ply = rag:GetOwner()
	if(!IsValid(ply))then 
		BSF_RAGDOLLCONTROL:KillRagdoll(rag,true)	--true here because you can't kill NULL entity
		return
	end
	if(!BSF_RAGDOLLCONTROL:CanMove(rag))then
		return
	end
	
	--local b_footl = rag.PhysBones["ValveBiped.Bip01_L_Foot"]
	--local b_footr = rag.PhysBones["ValveBiped.Bip01_R_Foot"]
	local footbase = BSF_RAGDOLLCONTROL:GetFootBase(rag)
	
	local eyeangs = ply:EyeAngles()

	local standfrac = BSF_RAGDOLLCONTROL:CanStand(rag)
	
	if(hook.Run("BSF_RAGDOLLCONTROL(PreBodyAnimation)",rag,eyeangs,footbase))then
		return
	end

	--vector_origin	

	if(standfrac)then
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = 0
		cureyeangs[2] = cureyeangs[2] + 90
		cureyeangs[3] = cureyeangs[3] + 90
		local b_pelvis = rag.PhysBones["ValveBiped.Bip01_Pelvis"]
		
		footbase,additiveeyeangs = BSF_RAGDOLLCONTROL:RagMovementThink(rag,ply,eyeangs,footbase)
		
		--footbase+vector_up*(35+_pelvis_flyadd)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_pelvis,footbase+vector_up*(35+_pelvis_flyadd),cureyeangs+additiveeyeangs)
	end
	
	local cureyeangs = Angle(eyeangs)
	cureyeangs[1] = -90
	cureyeangs[2] = cureyeangs[2] - 90
	cureyeangs[3] = cureyeangs[3]
	local b_spine2 = rag.PhysBones["ValveBiped.Bip01_Spine2"]
	BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine2,nil,cureyeangs)

	local cureyeangs = Angle(eyeangs)
	cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
	cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
	cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Spine4"]
	BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)
	
	local cureyeangs = Angle(eyeangs)
	--print(cureyeangs[1])
	cureyeangs[1] = math.Clamp(cureyeangs[1],-60,-16)
	cureyeangs[2] = cureyeangs[2]
	cureyeangs[3] = 90
	local b_head = rag.PhysBones["ValveBiped.Bip01_Head1"]
	BSF_RAGDOLLCONTROL:ControllPhysBone(b_head,nil,cureyeangs)
	
	hook.Run("BSF_RAGDOLLCONTROL(PostBodyAnimation)",rag,eyeangs,footbase)
end

function BSF_RAGDOLLCONTROL:RagMovementThink(rag,ply,eyeangs,footbase,additiveeyeangs)
	local moving = false
	local additiveeyeangs = Angle(0,0,0)
	local rate = 1
	--[[
	if(ply:KeyDown(IN_ATTACK))then
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_fists(idle)",rate)
	end
	]]
	
	if(ply:KeyDown(IN_FORWARD))then
		moving = true
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = 0
		if(ply:KeyDown(IN_MOVELEFT))then
			additiveeyeangs[2] = additiveeyeangs[2]+45
			cureyeangs[2] = cureyeangs[2] + 45
		elseif(ply:KeyDown(IN_MOVERIGHT))then
			additiveeyeangs[2] = additiveeyeangs[2]-45
			cureyeangs[2] = cureyeangs[2] - 45
		end
		
		if(ply:KeyDown(IN_SPEED))then
			rate = 1.5
		end
		local forward = cureyeangs:Forward()
		forward = forward*10*rate
		forward.z = 0
		footbase = footbase + forward
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,IN_FORWARD,rate)
	end
	if(ply:KeyReleased(IN_FORWARD))then
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,IN_FORWARD)
	end

	if(ply:KeyDown(IN_BACK) and !moving)then
		moving = true
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = 0
		if(ply:KeyDown(IN_MOVELEFT))then
			additiveeyeangs[2] = additiveeyeangs[2]-45
			cureyeangs[2] = cureyeangs[2] - 45
		elseif(ply:KeyDown(IN_MOVERIGHT))then
			additiveeyeangs[2] = additiveeyeangs[2]+45
			cureyeangs[2] = cureyeangs[2] + 45
		end
		
		if(ply:KeyDown(IN_SPEED))then
			rate = 1.2
		end
		local forward = cureyeangs:Forward()
		forward = forward*-10*rate
		forward.z = 0
		footbase = footbase + forward
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,IN_BACK,rate)
	end
	if(ply:KeyReleased(IN_BACK))then
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,IN_BACK)
	end
	
	if(ply:KeyDown(IN_MOVELEFT) and !moving)then
		moving = true
		rate = 0.8
		if(ply:KeyDown(IN_SPEED))then
			rate = 1
		end
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = 0
		cureyeangs[2] = cureyeangs[2] - 90
		local forward = cureyeangs:Forward()
		forward = forward*-10*rate
		forward.z = 0
		footbase = footbase + forward
		additiveeyeangs[2] = additiveeyeangs[2]+80
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,IN_FORWARD,rate)
	end
	if(ply:KeyReleased(IN_MOVELEFT))then
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,IN_MOVELEFT)
	end
	
	if(ply:KeyDown(IN_MOVERIGHT) and !moving)then
		moving = true
		rate = 0.8
		if(ply:KeyDown(IN_SPEED))then
			rate = 1
		end
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = 0
		cureyeangs[2] = cureyeangs[2] + 90
		local forward = cureyeangs:Forward()
		forward = forward*-10*rate
		forward.z = 0
		footbase = footbase + forward
		additiveeyeangs[2] = additiveeyeangs[2]-80
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,IN_FORWARD,rate)
	end
	if(ply:KeyReleased(IN_MOVERIGHT))then
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,IN_BACK)
	end
	
	if(!moving)then
		BSF_RAGDOLLCONTROL:LegMovement_Idle(rag)
	end
	
	return footbase,additiveeyeangs
end

function BSF_RAGDOLLCONTROL:LegMovement_ResetStartStatus(rag,mode)	--DEPRECATED
	--rag._RagAnimStart_Started = rag._RagAnimStart_Started or {}
	--rag._RagAnimStart_Started[mode] = nil
end

function BSF_RAGDOLLCONTROL:LegMovement_Walk(rag,mode) --DEPRECATED
	--
end

function BSF_RAGDOLLCONTROL:LegMovement_Idle(rag)
	BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"idle")
end