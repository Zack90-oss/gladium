--This is a first two-handed weapon of this gamemode
--This is the first weapon to utilize default gmod SWEP system
AddCSLuaFile()
SWEP.Base = "bsf_weapon_base"
SWEP.PrintName = "Axe"
SWEP.Instructions = "Woodcutter's standart issue two-handed axe"

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Initialize = function(self)
	self:AutoHooksCreate()
end

SWEP.Damage = 30
SWEP.DamageFist = 10
SWEP.TerminalSpeed = 120
--TerminalSpeedStab = 200,
SWEP.AttackCDStab = 0.3+0.2
SWEP.AttackCD = 0.1+0.2

SWEP.PostAnimDamageTime = 0.1

--AutoHook Table
--METHOD: Will add hooks to weapons copies and call similar function (WITH PREFIX "AutoHook_") in that copy then time comes
SWEP.AutoHooks = {
	"BSF_RAGDOLLCONTROL(PostBodyAnimation)",	--Will add this hook and run self.AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation) then needed
	"BSF_PHYSCONTROL(PhysicsCollide)",
}

//AutoHooks
SWEP["AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation)"] = function(self,comrag,eyeangs,footbase,additiveeyeangs)
	local ply = self.Owner
	if(!IsValid(ply) or !IsValid(ply:GetActiveWeapon()))then return nil end
	local rag = ply.BSF_Ragdoll
	if(comrag == rag and ply:GetActiveWeapon():GetClass()==self:GetClass())then --We want to animate only after our ragdoll body anim not any other
		--print(CurTime())
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

SWEP["AutoHook_BSF_PHYSCONTROL(PhysicsCollide)"] = function(self,ent,data)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local b_handR = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	-- or (ent == rag and data.PhysObject==b_handR)
	if(((ent==self.WeaponEnt and data.HitEntity!=rag) )and BSF_RAGDOLLCONTROL_WEAPONS:IsTargetSoft(data.HitEntity))then	--Making sure we can't harm ourselves(We can't possibly actually> Why? Because Garry's)
		if((self:IsAttackingAny()) and !self.DealtDamage)then
			speed = data.HitSpeed:Length()
			if(speed)then
				local frac = math.min(speed/self.TerminalSpeed,1)
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
	wep.BSF_PreventUse = true
	
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

	if(!IsValid(self.WeaponEnt))then return end
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	local handangs = b_hand:GetAngles()
	handangs:RotateAroundAxis(handangs:Forward(),90)
	handangs:RotateAroundAxis(handangs:Up(),-10)
	
	local phys = self.WeaponEnt:GetPhysicsObject()

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
	return true
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
				--print(23,endtime-CurTime())
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
			if(!info._GMODSWEPCorrected)then --For some bizzare reason this thing adds EXACTLY 4 extra frames when done in GMOD SWEP system which seems to ruin repetitive animations
				info._GMODSWEPCorrected = true
				self.AttackingTable[id].AnimEndTime = self.AttackingTable[id].AnimEndTime - 4*engine.TickInterval()
			end
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
	--ply:ChatPrint(CurTime())
	local rag = ply.BSF_Ragdoll
	
	self.AttackingTable = self.AttackingTable or {}
	self.AttackingTable[mode] = {}
	local atk = self.AttackingTable[mode]
	atk.Anim = mode
	atk.Rate = 1
	atk.AnimEndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)
	--print(atk.AnimEndTime-CurTime())
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
