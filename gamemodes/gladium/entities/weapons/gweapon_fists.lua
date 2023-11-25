AddCSLuaFile()
SWEP.Base = "bsf_weapon_base"
SWEP.PrintName = "Fists"
SWEP.Instructions = "Bare fists"

SWEP.Slot = 0
SWEP.SlotPos = 2

SWEP.Initialize = function(self)
	self:AutoHooksCreate()
end

SWEP.Damage = 8
SWEP.TerminalSpeed = 200
--TerminalSpeedStab = 200,
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
		local atkdir = nil
		if(self.Attacking1)then
			atkdir = (atkdir or 0) - 40
		end
		if(self.Attacking2)then
			atkdir = (atkdir or 0) + 40
		end
		
		if(atkdir)then
			local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Spine4"]
			local b_spine4ang = b_spine4:GetAngles()

			--Spine 4
			local cureyeangs = Angle(eyeangs)
			cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
			cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
			cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
			cureyeangs:RotateAroundAxis(b_spine4ang:Forward(),atkdir)
			BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)
		end
	end
end

SWEP["AutoHook_BSF_PHYSCONTROL(PhysicsCollide)"] = function(self,ent,data)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	if(rag==ent)then
		if((self.AttackingDamage1 or self.AttackingDamage2) and !self.DealtDamage)then
			local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
			local b_handR = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
			
			local speed = nil
			if(data.PhysObject == b_handL)then
				speed = data.HitSpeed:Length()
			elseif(data.PhysObject == b_handR)then
				speed = data.HitSpeed:Length()
			end
			if(speed)then
				local frac = math.min(speed/self.TerminalSpeed,1)
				--data.HitEntity:TakeDamage(math.Round(self.Damage*frac))
				
				local dmg = DamageInfo()
				dmg:SetDamage(math.Round(self.Damage*frac))
				dmg:SetDamageType(DMG_CLUB)
				dmg:SetDamagePosition(data.HitPos)
				dmg:SetInflictor(ent)
				dmg:SetAttacker(self.Owner)
				---data.HitEntity:TakeDamageInfo(dmg)
				BSF_RAGDOLLCONTROL:ApplyDamage(data.HitEntity,dmg,data.HitObject)
				
				rag:EmitSound("ambient/voices/citizen_punches2.wav",math.max(frac*80,50))
				self.DealtDamage = true
			end
		end
	end
end
//AutoHooks

SWEP.Deploy = function(self)

end

SWEP.Holster = function(self,swtichto)
	self:StopAttacks()
	return true
end

SWEP.OnRemove = function(self)
	self:StopAttacks()
end

SWEP.StopAttacks = function(self)
	self.Attacking1 = nil
	self.AttackingDamage1 = nil
	self.Attacking2 = nil
	self.AttackingDamage2 = nil
	self.DealtDamage = nil
end

SWEP.Think = function(self)	--Called every tick
	if(SERVER)then	--Only execute on server
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_fists(idle)",1)
		
		if(self.Attacking1)then
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_fists(punch_left)",1)
		end
		if(self.Attacking1 and self.Attacking1<=CurTime())then
			self.Attacking1 = nil
			self.NextAttack = CurTime()+self.AttackCD
		end
		if(self.AttackingDamage1 and self.AttackingDamage1<=CurTime())then
			self.AttackingDamage1 = nil
			self.DealtDamage = nil
		end
		
		if(self.Attacking2)then
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_fists(punch_right)",1)
		end
		if(self.Attacking2 and self.Attacking2<=CurTime())then
			self.Attacking2 = nil
			self.NextAttack = CurTime()+self.AttackCD
		end
		if(self.AttackingDamage2 and self.AttackingDamage2<=CurTime())then
			self.AttackingDamage2 = nil
			self.DealtDamage = nil
		end
		
		if(self.NextAttack and self.NextAttack<=CurTime())then
			self.NextAttack = nil
		end
		
		if(BSF_RAGDOLLCONTROL:GetKeyDown(ply,IN_ATTACK) and !self.Attacking1 and !self.NextAttack)then
			self:Attack(1)
		end
		if(BSF_RAGDOLLCONTROL:GetKeyDown(ply,IN_ATTACK2) and !self.Attacking2 and !self.NextAttack)then
			self:Attack(2)
		end
	end
end

SWEP.Attack = function(self,mode)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	
	local eyevec = ply:GetAimVector()
	
	if(mode == 1)then
		self.Attacking1 = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,"weapon_fists(punch_left)")
		self.AttackingDamage1 = self.Attacking1 + self.PostAnimDamageTime
	else
		self.Attacking2 = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,"weapon_fists(punch_right)")
		self.AttackingDamage2 = self.Attacking2 + self.PostAnimDamageTime
	end
	self.DealtDamage = nil
end
--}
--BSF_RAGDOLLCONTROL_WEAPONS:ReloadAllWeaponScripts(self.Class)
