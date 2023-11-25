AddCSLuaFile()
SWEP.Base = "bsf_weapon_base"
SWEP.PrintName = "Knife"
SWEP.Instructions = "Knife stained with dry blood"

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Initialize = function(self)
	self:AutoHooksCreate()
end

SWEP.Damage = 16
SWEP.DamageFist = 10
SWEP.TerminalSpeed = 100
SWEP.TerminalSpeedStab = 200
SWEP.AttackCDStab = 0.3
SWEP.AttackCD = 0.1

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
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_knife(idle)",1)
		self:AttackThink()	--Everything better postbodyanims
		
		local atkdir = nil
		if(self:IsAttackingAnim("weapon_knife(stab)"))then
			atkdir = (atkdir or 0) + 40
		end
		
		if(atkdir)then
			ARG_Tilt = atkdir	--Needed animation argument
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"arg-weapon_knife(corrective_atkdir)",1)
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
				--data.HitEntity:TakeDamage(math.Round(self.Damage*frac))
				
				local dmg = DamageInfo()
				dmg:SetDamage(math.Round(self.Damage*frac))
				dmg:SetDamageType(DMG_SLASH)
				dmg:SetDamagePosition(data.HitPos)
				dmg:SetInflictor(ent)
				dmg:SetAttacker(self.Owner)
				---data.HitEntity:TakeDamageInfo(dmg)
				BSF_RAGDOLLCONTROL:ApplyDamage(data.HitEntity,dmg,data.HitObject)
				
				rag:EmitSound("weapons/knife/knife_hit1.wav",math.max(frac*80,50))
				local effectdata = EffectData()
				effectdata:SetOrigin( data.HitPos )
				util.Effect( "BloodImpact", effectdata )
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

table.Merge(SWEP,{	--Easy way of creating rest of the SWEP from legacy BSF SWEP system
	RemoveWeaponEnt = function(self)
		if(CLIENT)then return end
		local wep = self.WeaponEnt
		if(IsValid(wep))then
			wep:Remove()
		end
	end,

	CreateWeaponEnt = function(self)
		if(CLIENT)then return end
		if(IsValid(self.WeaponEnt))then return end	--We dont wanna stack these
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		if(!IsValid(rag))then return end
		
		local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
		local handangs = b_hand:GetAngles()
		handangs:RotateAroundAxis(handangs:Forward(),180)
		handangs:RotateAroundAxis(handangs:Right(),45)
		--[[
		handangs:RotateAroundAxis(handangs:Forward(),180)
		handangs:RotateAroundAxis(handangs:Right(),-45)
		]]
		
		self.WeaponEnt = ents.Create("prop_physics")
		local wep = self.WeaponEnt
		wep:SetModel("models/weapons/w_knife_t.mdl")
		--wep:SetPos(b_hand:GetPos()+b_hand:GetAngles():Forward()*0+b_hand:GetAngles():Right()*1.5+b_hand:GetAngles():Up()*3)
		wep:SetPos(b_hand:GetPos()+b_hand:GetAngles():Forward()*0+b_hand:GetAngles():Right()*1.5+b_hand:GetAngles():Up()*0)
		wep:SetAngles(handangs)
		BSF_PHYSCONTROL:AddPhysCollideCallBack(wep)
		wep:Spawn()
		wep:Activate()
		--constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_hand])
		constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_hand],0,true,false)
	end,
	
	Think = function(self)
		if(SERVER)then	--Only execute on server
			local ply = self.Owner
			local rag = ply.BSF_Ragdoll
			
			if(self.NextAttack and self.NextAttack<=CurTime())then
				self.NextAttack = nil
			end
			
			local atkang,mw = BSF_RAGDOLLCONTROL:GetAttackAngle(ply)
			if(mw>0)then
				if(!self.NextAttack)then
					self:Attack("weapon_knife(stab)")
				end
			end
			
			if(BSF_RAGDOLLCONTROL:GetKeyDown(ply,IN_ATTACK))then
				if(!self.NextAttack)then
					local endtime = nil
					if(BSF_RAGDOLLCONTROL:IsAttackAngleIn(ply,-90,90))then
						endtime = self:Attack("weapon_knife(slash-right)")
					else
						endtime = self:Attack("weapon_knife(slash-left)")
						--self:Attack("weapon_knife(stab)")
					end
					endtime = endtime + 1
					BSF_RAGDOLLCONTROL:SendAttackAngle(ply,endtime-CurTime())
				end
			end
		end
	end,
	
	AttackThink = function(self)
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		self.AttackingTable = self.AttackingTable or {}
		
		for id,info in pairs(self.AttackingTable)do
			if(info.EndTime<=CurTime())then
				self.AttackingTable[id] = nil
				self.DealtDamage = nil
			elseif(info.AnimEndTime>CurTime())then
				BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,info.Anim,info.Rate)
			end
		end
	end,

	IsAttacking = function(self,atkid)
		self.AttackingTable = self.AttackingTable or {}
		return self.AttackingTable[atkid]~=nil
	end,
	
	IsAttackingAnim = function(self,atkid)
		self.AttackingTable = self.AttackingTable or {}
		return (self.AttackingTable[atkid] and self.AttackingTable[atkid].AnimEndTime>CurTime())
	end,

	IsAttackingAny = function(self)
		self.AttackingTable = self.AttackingTable or {}
		return (next(self.AttackingTable) ~= nil)
	end,
	
	Attack = function(self,mode)
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		self.AttackingTable = self.AttackingTable or {}
		self.AttackingTable[mode] = {}
		local atk = self.AttackingTable[mode]
		atk.Anim = mode
		atk.Rate = 1
		atk.AnimEndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)
		atk.EndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)+self.PostAnimDamageTime
		if(mode=="weapon_knife(stab)")then
			self.NextAttack = atk.EndTime+self.AttackCDStab
		else
			self.NextAttack = atk.EndTime+self.AttackCD
		end
		
		self.DealtDamage = nil
		
		return atk.AnimEndTime
	end,
})