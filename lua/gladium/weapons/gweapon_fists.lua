//You better look in gweapon_knife for better code


local _NAME = "gweapon_fists"
BSF_RAGDOLLCONTROL_WEAPONS.Weapons[_NAME] = {
	--Important
	Class = _NAME,
	_Valid = true,
	IsValid = function(self)
		if(!IsValid(self.Owner)) or (self.Owner.Alive and !self.Owner:Alive())then
			return false
		end
		return self._Valid
	end,
	--Important
	
	Damage = 8,
	TerminalSpeed = 200,
	AttackCD = 0.1,
	
	PostAnimDamageTime = 0.1,
	
	--AutoHook Table
	--METHOD: Will add hooks to weapons copies and call similar named function (WITH PREFIX "AutoHook_")(pattern[(){}/.%[%] ] WILL BE REMOVED) in that copy then time comes
	AutoHooks = {
		"BSF_RAGDOLLCONTROL(PostBodyAnimation)",	--Will add this hook and run self.AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation) then needed
		"BSF_PHYSCONTROL(PhysicsCollide)",
	},
	
	//AutoHooks
	AutoHook_BSF_RAGDOLLCONTROLPostBodyAnimation = function(self,rag,eyeangs,footbase,additiveeyeangs)
		if(rag == self.Owner.BSF_Ragdoll and BSF_RAGDOLLCONTROL_WEAPONS:IsWeaponActive(rag,_NAME))then --We want to animate only after our ragdoll body anim not any other
			local ply = self.Owner
			local rag = ply.BSF_Ragdoll
			
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
	end,

	AutoHook_BSF_PHYSCONTROLPhysicsCollide = function(self,ent,data)
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
	end,
	//AutoHooks
	
	Initialize = function(self)	--Called one time(and during weapon updates(#FIXME))
		
	end,
	
	StopAttacks = function(self)
		self.Attacking1 = nil
		self.AttackingDamage1 = nil
		self.Attacking2 = nil
		self.AttackingDamage2 = nil
		self.DealtDamage = nil
	end,
	
	Deploy = function(self)
		
	end,
	
	Holster = function(self,swtichto)
		self:StopAttacks()
	end,
	
	OnRemove = function(self)
		self:StopAttacks()
	end,
	
	Think = function(self)	--Called every tick
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
	end,
	
	Attack = function(self,mode)
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
	end,
}
--BSF_RAGDOLLCONTROL_WEAPONS:ReloadAllWeaponScripts(_NAME)