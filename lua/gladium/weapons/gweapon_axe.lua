--This is a first two-handed weapon of this gamemode

--This weapon uses new swep(non gmod) system
--You can code in any style you want

--BSF_RAGDOLLCONTROL_WEAPONS.Weapons[self.Class] = {
SWEP.Damage = 30
SWEP.DamageFist = 10
SWEP.TerminalSpeed = 120
--TerminalSpeedStab = 200,
SWEP.AttackCDStab = 0.3+0.2
SWEP.AttackCD = 0.1+0.2

SWEP.PostAnimDamageTime = 0.1

--AutoHook Table
--METHOD: Will add hooks to weapons copies and call similar self.Classd function (WITH PREFIX "AutoHook_")(pattern[(){}/.%[%] ] WILL BE REMOVED) in that copy then time comes
SWEP.AutoHooks = {
	"BSF_RAGDOLLCONTROL(PostBodyAnimation)",	--Will add this hook and run self.AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation) then needed
	"BSF_PHYSCONTROL(PhysicsCollide)",
}

//AutoHooks
SWEP["AutoHook_BSF_RAGDOLLCONTROLPostBodyAnimation"] = function(self,rag,eyeangs,footbase,additiveeyeangs)
	if(rag == self.Owner.BSF_Ragdoll and BSF_RAGDOLLCONTROL_WEAPONS:IsWeaponActive(rag,self.Class))then --We want to animate only after our ragdoll body anim not any other
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		--[[
		if(IsValid(self.WeaponEnt) and !self:IsAttacking("weapon_axe(stab)"))then
			local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
			ARG_Pos = self:GetLeftHandPos()
			ARG_Ent = b_handL
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"arg_weapon_axe(idle)",1)
		end
		]]
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"arg_weapon_axe(idle)",1)
		self:AttackThink()	--Everything better postbodyanims
		
		local atkdir = nil
		if(self:IsAttackingAnim("weapon_axe(stab)"))then
			atkdir = (atkdir or 0) + 40
		end
		
		if(atkdir)then
			ARG_Tilt = atkdir	--Needed animation argument
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"arg-weapon_axe(corrective_atkdir)",1)
		end
	end
end

SWEP["AutoHook_BSF_PHYSCONTROLPhysicsCollide"] = function(self,ent,data)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local b_handR = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	-- or (ent == rag and data.PhysObject==b_handR)
	if(((ent==self.WeaponEnt and data.HitEntity!=rag) )and BSF_RAGDOLLCONTROL_WEAPONS:IsTargetSoft(data.HitEntity))then	--Making sure we can't harm ourselves(We can't possibly actually> Why? Because Garry's)
		if((self:IsAttackingAny()) and !self.DealtDamage)then
			speed = data.HitSpeed:Length()
			if(speed)then
				local frac = math.min(speed/self.TerminalSpeed,1)
				--[[
				if(ent == rag and data.PhysObject==b_handR) then
					local frac = math.min(speed/self.TerminalSpeed,1)
					data.HitEntity:TakeDamage(math.Round(self.DamageFist*frac))
					rag:EmitSound("ambient/voices/citizen_punches2.wav",math.max(frac*80,50))
				else
				]]
					--data.HitEntity:TakeDamage(math.Round(self.Damage*frac))
					frac = frac*self:GetCurAttackDmgMul()
					
					local dmg = DamageInfo()
					dmg:SetDamage(math.Round(self.Damage*frac))
					dmg:SetDamageType(DMG_CLUB)
					dmg:SetDamagePosition(data.HitPos)
					dmg:SetInflictor(ent)
					dmg:SetAttacker(self.Owner)
					---data.HitEntity:TakeDamageInfo(dmg)
					BSF_RAGDOLLCONTROL:ApplyDamage(data.HitEntity,dmg,data.HitObject)
					
					rag:EmitSound("weapons/knife/knife_hit1.wav",math.max(frac*80,50))
					local effectdata = EffectData()
					effectdata:SetOrigin( data.HitPos )
					util.Effect( "BloodImpact", effectdata )
				--end
				self.DealtDamage = true
			end
			--weapons/knife/knife_hit1.wav
			-- -
			--weapons/knife/knife_hit4.wav
			self.DealtDamage = true
		end
	end
end
//AutoHooks

SWEP.Initialize = function(self)
	
end


local function _CalcBallsocketMinMax(angs, xmin, ymin, zmin, xmax, ymax, zmax)
	
	
	
	return xmin, ymin, zmin, xmax, ymax, zmax
end

local MAX_CONSTRAINTS_PER_SYSTEM = 100
local CurrentSystem = nil
local SystemLookup = {}

local function ConstraintCreated( Constraint )
	assert( IsValid( CurrentSystem ) )
	SystemLookup[ Constraint ] = CurrentSystem
	CurrentSystem.__ConstraintCount = ( CurrentSystem.__ConstraintCount or 0 ) + 1
end


local function CreateConstraintSystem()

	local iterations = GetConVarNumber( "gmod_physiterations" )

	local csystem = ents.Create( "phys_constraintsystem" )
	if ( !IsValid( csystem ) ) then return end

	csystem:SetKeyValue( "additionaliterations", iterations )
	csystem:Spawn()
	csystem:Activate()
	csystem.__ConstraintCount = 0

	return csystem

end

local function FindOrCreateConstraintSystem( Ent1, Ent2 )

	local System = nil

	Ent2 = Ent2 or Ent1

	-- Does Ent1 have a constraint system?
	if ( !Ent1:IsWorld() && IsValid( Ent1.ConstraintSystem ) && !Ent1.ConstraintSystem.__BadConstraintSystem ) then
		System = Ent1.ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( IsValid( System ) && ( System.__ConstraintCount or 0 ) >= MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end

	-- Does Ent2 have a constraint system?
	if ( !IsValid( System ) && !Ent2:IsWorld() && IsValid( Ent2.ConstraintSystem ) && !Ent2.ConstraintSystem.__BadConstraintSystem ) then
		System = Ent2.ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( IsValid( System ) && ( System.__ConstraintCount or 0 ) >= MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end

	-- No constraint system yet (Or they're both full) - make a new one
	if ( !IsValid( System ) ) then

		--Msg( "New Constrant System\n" )
		System = CreateConstraintSystem()

	end

	Ent1.ConstraintSystem = System
	Ent2.ConstraintSystem = System

	return System

end


local function onStartConstraint( Ent1, Ent2 )

	-- Get constraint system
	CurrentSystem = FindOrCreateConstraintSystem( Ent1, Ent2 )

	-- Any constraints called after this call will use this system
	SetPhysConstraintSystem( CurrentSystem )

end


local function onFinishConstraint( Ent1, Ent2 )

	-- Turn off constraint system override
	CurrentSystem = nil
	SetPhysConstraintSystem( NULL )

end

local function BSF_AdvBallsocket( Ang, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, xmin, ymin, zmin, xmax, ymax, zmax, xfric, yfric, zfric, onlyrotation, nocollide )

	if ( !constraint.CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !constraint.CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	-- local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end

	-- Make Constraint
	onStartConstraint( Ent1, Ent2 )

		local flags = 0
		if ( onlyrotation && onlyrotation > 0 ) then flags = flags + 2 end
		if ( nocollide && nocollide > 0 ) then flags = flags + 1 end

		local Constraint = ents.Create( "phys_ragdollconstraint" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos1 )
		Constraint:SetAngles( Ang )
		Constraint:SetKeyValue( "xmin", xmin )
		Constraint:SetKeyValue( "xmax", xmax )
		Constraint:SetKeyValue( "ymin", ymin )
		Constraint:SetKeyValue( "ymax", ymax )
		Constraint:SetKeyValue( "zmin", zmin )
		Constraint:SetKeyValue( "zmax", zmax )
		if ( xfric && xfric > 0 ) then Constraint:SetKeyValue( "xfriction", xfric ) end
		if ( yfric && yfric > 0 ) then Constraint:SetKeyValue( "yfriction", yfric ) end
		if ( zfric && zfric > 0 ) then Constraint:SetKeyValue( "zfriction", zfric ) end
		if ( forcelimit && forcelimit > 0 ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
		if ( torquelimit && torquelimit > 0 ) then Constraint:SetKeyValue( "torquelimit", torquelimit ) end
		Constraint:SetKeyValue( "spawnflags", flags )
		Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )
	constraint.AddConstraintTable( Ent1, Constraint, Ent2 )

	local ctable = {
		Type = "AdvBallsocket",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		forcelimit = forcelimit,
		torquelimit = torquelimit,
		xmin = xmin,
		ymin = ymin,
		zmin = zmin,
		xmax = xmax,
		ymax = ymax,
		zmax = zmax,
		xfric = xfric,
		yfric = yfric,
		zfric = zfric,
		onlyrotation = onlyrotation,
		nocollide = nocollide
	}

	Constraint:SetTable( ctable )

	return Constraint

end

SWEP.GetLeftHandPos = function(self)
	return self.WeaponEnt:GetPos()+self.WeaponEnt:GetAngles():Right()*2+self.WeaponEnt:GetAngles():Up()*-1.5+self.WeaponEnt:GetAngles():Forward()*-4
end

SWEP.GetLeftHandAng = function(self)
	local angs = self.WeaponEnt:GetAngles()
	angs:RotateAroundAxis(angs:Forward(),-90)
	--angs:RotateAroundAxis(angs:Up(),-90)
	return angs
end

SWEP.RemoveWeaponEnt = function(self)
	if(CLIENT)then return end
	local wep = self.WeaponEnt
	if(IsValid(wep))then
		wep:Remove()
	end
end

SWEP.PositionWeaponEnt = function(self)
	if(CLIENT)then return end
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local wep = self.WeaponEnt
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	local handangs = b_handL:GetAngles()
	handangs:RotateAroundAxis(handangs:Forward(),-90)
	handangs:RotateAroundAxis(handangs:Up(),-10)
	handangs:RotateAroundAxis(handangs:Right(),-15)
	
	wep:SetPos(b_handL:GetPos()+b_handL:GetAngles():Forward()*3.5+b_handL:GetAngles():Right()*1.5+b_handL:GetAngles():Up()*5)
	wep:SetAngles(handangs)
end

SWEP.PositionHand = function(self,up)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	up = up or 0
	local b_handR = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	b_handR:SetPos(self:GetLeftHandPos()+self.WeaponEnt:GetAngles():Right()*up)
	b_handR:SetAngles(self:GetLeftHandAng())
end

SWEP.WeldWeaponEnt = function(self)
	if(CLIENT)then return end
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local wep = self.WeaponEnt
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	local locvec = b_handL:GetPos()
	locvec = locvec + b_handL:GetAngles():Forward()*4 + b_handL:GetAngles():Up()*-1 + b_handL:GetAngles():Right()*1
	locvec = b_handL:WorldToLocal(locvec)
	constraint.Ballsocket(wep,rag,0,rag._PhysToBonesNum[b_handL],locvec,0,0)
	--constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_handL],0,false,false)
end


SWEP.WeldWeaponLHandEnt = function(self)
	if(CLIENT)then return end
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local wep = self.WeaponEnt
	local b_handL = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	local locvec = self:GetLeftHandPos()
	locvec = locvec + b_handL:GetAngles():Forward()*4 + b_handL:GetAngles():Up()*-1 + b_handL:GetAngles():Right()*1
	--locvec = b_handL:WorldToLocal(locvec)
	self.WeaponLHANDWeld = constraint.Ballsocket(wep,rag,0,rag._PhysToBonesNum[b_handL],b_handL:WorldToLocal(locvec),0,0)--constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_handL],0,false,false)
	--[[
	local min = - 180
	local max = 180
	
	local wepangs = wep:GetAngles()
	
	local xmin, ymin, zmin, xmax, ymax, zmax = _CalcBallsocketMinMax(wepangs,		
		0, --X Min
		0, --Y Min
		min, --Z Min
		0, --X Max
		0, --Y Max
		max --Z Max
	)
	print(xmin, ymin, zmin, xmax, ymax, zmax)
	
	self.WeaponLHANDWeld = BSF_AdvBallsocket(wepangs,wep,rag,0,rag._PhysToBonesNum[b_handL],wep:WorldToLocal(locvec),b_handL:WorldToLocal(locvec),0,0, 
		xmin, ymin, zmin, xmax, ymax, zmax,
		
		0,	--X Fric
		0,  --Y Fric
		0,  --Z Fric
		
		0,
		0
	)
	--self.WeaponLHANDWeld:SetAngles(wepangs)
	

	--print(rag._PhysToBonesNum[b_handL])
	--local loch = b_handL:WorldToLocal(wep:GetPos())
	--local locw = wep:WorldToLocal(b_handL:GetPos())
	--constraint.Slider(wep,rag,0,rag._PhysToBonesNum[b_handL],locw,loch,1,"",color_white)
	]]
end

SWEP.UnWeldWeaponLHandEnt = function(self)
	if(CLIENT)then return end
	local wep = self.WeaponEnt
	if(IsValid(self.WeaponLHANDWeld))then
		self.WeaponLHANDWeld:Remove()
	end
end

SWEP.UnWeldWeaponEnt = function(self)
	if(CLIENT)then return end
	local wep = self.WeaponEnt
	constraint.RemoveConstraints(wep,"Ballsocket")
	--constraint.RemoveConstraints(wep,"Weld")
end

SWEP.CreateWeaponEnt = function(self)
	--if(1)then return end
	if(CLIENT)then return end
	if(IsValid(self.WeaponEnt))then return end
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	if(!IsValid(rag))then return end
	
	
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	local handangs = b_hand:GetAngles()
	handangs:RotateAroundAxis(handangs:Forward(),90)
	handangs:RotateAroundAxis(handangs:Up(),-10)
	--handangs:RotateAroundAxis(handangs:Right(),90 + 45)
	
	self.WeaponEnt = ents.Create("prop_physics")
	local wep = self.WeaponEnt
	wep:SetModel("models/props/cs_militia/axe.mdl")
	--wep:SetPos(b_hand:GetPos()+b_hand:GetAngles():Forward()*3.5+b_hand:GetAngles():Right()*1.5+b_hand:GetAngles():Up()*-5)
	--wep:SetAngles(handangs)
	self:PositionWeaponEnt()
	BSF_PHYSCONTROL:AddPhysCollideCallBack(wep)
	wep:Spawn()
	wep:Activate()
	
	wep:GetPhysicsObject():SetMass(1)
	wep:GetPhysicsObject():SetDragCoefficient(0)
	constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_hand])
	constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_handL])
	--constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_hand],0,true,false)
	self:WeldWeaponEnt()
	
	self:PositionHand(3)
	self:WeldWeaponLHandEnt()
	
	--wep:GetPhysicsObject():EnableMotion(false)
	--self.WeaponLHANDWeld = constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_handL],0,true,false)
end

function SWEP:AlignWeapon()
--[[
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	b_hand:SetAngles(self:GetLeftHandAng())
	]]
	if(!IsValid(self.WeaponEnt))then return end
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	local handangs = b_hand:GetAngles()
	handangs:RotateAroundAxis(handangs:Forward(),90)
	handangs:RotateAroundAxis(handangs:Up(),-10)
	
	local phys = self.WeaponEnt:GetPhysicsObject()
	--local angs = handangs:Forward()-phys:GetAngles():Forward()
	--angs = angs + phys:GetAngleVelocity()*engine.TickInterval()
	--print(angs)
	--phys:AlignAngles(angs,handangs)
	--phys:ApplyTorqueCenter(angs)
	_BSF_RAGDOLLCONTROL_shadow_data.maxangular = 120
	_BSF_RAGDOLLCONTROL_shadow_data.maxangulardamp = 40
	BSF_RAGDOLLCONTROL:ControllPhysBone(phys,nil,handangs)
	_BSF_RAGDOLLCONTROL_shadow_data.maxangular = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangular
	_BSF_RAGDOLLCONTROL_shadow_data.maxangulardamp = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangulardamp
end

SWEP.StopAttacks = function(self)
	self.AttackingTable = {}
end

SWEP.Deploy = function(self)
	self:CreateWeaponEnt()
end

SWEP.Holster = function(self,swtichto)
	self:StopAttacks()
	self:RemoveWeaponEnt()
end

SWEP.OnRemove = function(self)
	self:StopAttacks()
	self:RemoveWeaponEnt()
end

SWEP.Think = function(self)
	if(SERVER)then	--Only execute on server
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		self:AlignWeapon()
		
		if(self.NextAttack and self.NextAttack<=CurTime())then
			self.NextAttack = nil
		end
		
		local atkang,mw = BSF_RAGDOLLCONTROL:GetAttackAngle(ply)
		if(mw>0)then
			if(!self.NextAttack)then
				self:Attack("weapon_axe(stab)")
			end
		end
		
		if(BSF_RAGDOLLCONTROL:GetKeyDown(ply,IN_ATTACK))then
			if(!self.NextAttack)then
				local endtime = nil
				if(BSF_RAGDOLLCONTROL:IsAttackAngleIn(ply,-90,90))then
					endtime = self:Attack("weapon_axe(slash-right)")
				else
					endtime = self:Attack("weapon_axe(slash-left)")
					--self:Attack("weapon_knife(stab)")
				end
				endtime = endtime + 1
				BSF_RAGDOLLCONTROL:SendAttackAngle(ply,endtime-CurTime())
			end
		end
	end
end

SWEP.AttackThink = function(self)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	
	self.AttackingTable = self.AttackingTable or {}
	
	for id,info in pairs(self.AttackingTable)do
		self:AttackThink_Item(info)
		if(info.EndTime<=CurTime())then
			self.AttackingTable[id] = nil
			self.DealtDamage = nil
		elseif(info.AnimEndTime>CurTime())then
			print(info.AnimEndTime - CurTime())
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,info.Anim,info.Rate)
			if(info.DamageStartTime and info.DamageStartTime<=CurTime())then
				info.DamageStartTime = nil
			end
		end
	end
end

SWEP.AttackThink_Item = function(self,atk)

end

SWEP.IsAttacking = function(self,atkid)
	self.AttackingTable = self.AttackingTable or {}
	if(self.AttackingTable[atkid])then
		return !self.AttackingTable[atkid].DamageStartTime
	end
end

SWEP.IsAttackingAnim = function(self,atkid)
	self.AttackingTable = self.AttackingTable or {}
	return (self.AttackingTable[atkid] and self.AttackingTable[atkid].AnimEndTime>CurTime())
end

SWEP.IsAttackingAny = function(self)
	self.AttackingTable = self.AttackingTable or {}
	for mode,atk in pairs(self.AttackingTable)do
		return !atk.DamageStartTime
	end
end

SWEP.AttackDamageMuls = {
	["weapon_axe(stab)"]=0.7,
}

SWEP.GetCurAttackDmgMul = function(self)
	self.AttackingTable = self.AttackingTable or {}
	local mul = 1
	for mode,atk in pairs(self.AttackingTable)do
		mul = mul*(self.AttackDamageMuls[mode] or 1)
	end
	return mul
end

SWEP.AttackDamageStarts = {
	["weapon_axe(slash-right)"]=0.2,
	["weapon_axe(slash-left)"]=0.2,
}

SWEP.Attack = function(self,mode)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	
	self.AttackingTable = self.AttackingTable or {}
	self.AttackingTable[mode] = {}
	local atk = self.AttackingTable[mode]
	atk.Anim = mode
	atk.Rate = 1
	atk.AnimEndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)
	atk.EndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)+self.PostAnimDamageTime
	
	if(self.AttackDamageStarts[mode])then
		atk.DamageStartTime = CurTime()+self.AttackDamageStarts[mode]
	end
	
	if(mode=="weapon_axe(stab)")then
		--atk._StabInited = 2
		--print(CurTime())
		--self:UnWeldWeaponLHandEnt()
		self.NextAttack = atk.EndTime+self.AttackCDStab
	else
		self.NextAttack = atk.EndTime+self.AttackCD
	end
	
	self.DealtDamage = nil
	
	return atk.AnimEndTime
end
--}
--BSF_RAGDOLLCONTROL_WEAPONS:ReloadAllWeaponScripts(self.Class)
