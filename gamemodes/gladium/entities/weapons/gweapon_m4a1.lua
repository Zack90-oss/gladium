AddCSLuaFile()
SWEP.Base = "bsf_weapon_base"
SWEP.PrintName = "M4A1"
SWEP.Instructions = "m4a1"

SWEP.Slot = 0
SWEP.SlotPos = 2

SWEP.Initialize = function(self)
	self:AutoHooksCreate()
end

SWEP.Damage = 15

SWEP.ShootDamage = 16
SWEP.ShootForce = 4

SWEP.TerminalSpeed = 110
SWEP.AttackCD = 0.3
SWEP.AttackCDStab = 0.4

SWEP.ShootCD = 60/730--0.10

SWEP.PostAnimDamageTime = 0.1

SWEP.Primary.ClipSize		= 30		-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"

--AutoHook Table
--METHOD: Will add hooks to weapons copies and call similar function (WITH PREFIX "AutoHook_") in that copy then time comes
SWEP.AutoHooks = {
	"BSF_RAGDOLLCONTROL(PostBodyAnimation)",	--Will add this hook and run self.AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation) then needed
	"BSF_PHYSCONTROL(PhysicsCollide)",
	"BSF_CalcWeaponViewOffsetAngles",
}

SWEP["AutoHook_BSF_CalcWeaponViewOffsetAngles"] = function(self,pos,angles,fov)
	if(!IsValid(self))then return nil end
	
	local ply = self.Owner
	--print(self.Reloading)
	if(IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()==self:GetClass())then
		if(ply:KeyDown(IN_ATTACK2) and !self.Reloading and ply:KeyDown(IN_USE))then
			local wep = self:GetWeaponEnt()
			if(IsValid(wep))then
				local rag = BSF_RAGDOLLCONTROL:GetRagdoll()
				local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
				local bonepos = rag:GetBonePosition(bone)
				
				local wepangs = wep:GetAngles()
				local weppos = wep:GetPos() + wepangs:Forward()*-16 + wepangs:Up()*11.6
				
				
				--local angs = LerpAngle(BSF_RAGDOLLCONTROL:GetWVAChangeFraction(self),angles,(weppos-bonepos):Angle())
				--print(angles,"gay",angs)
				return (weppos-bonepos):Angle(),weppos:Distance(bonepos),BSF_RAGDOLLCONTROL:GetWVAChangeFraction(self)
				
				--[[
				local angs = wep:GetAngles()
				local pos = wep:GetPos() + angs:Forward()*-14 + angs:Up()*9.9
				
				return BSF_RAGDOLLCONTROL:CalcWeaponView(wep,view,pos,angs,8,20)
				]]
			end
		end
	end
end

//AutoHooks
SWEP["AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation)"] = function(self,comrag,eyeangs,footbase,additiveeyeangs)
	local ply = self.Owner
	if(!IsValid(ply) or !IsValid(ply:GetActiveWeapon()))then return nil end
	local rag = ply.BSF_Ragdoll
	if(comrag == rag and ply:GetActiveWeapon():GetClass()==self:GetClass())then --We want to animate only after our ragdoll body anim not any other
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		if(ply:KeyDown(IN_ATTACK2) and !BSF_RAGDOLLCONTROL_ANIMATION:IsAnimating(rag,"weapon_m4a1(reload)") and !self.Reloading)then
			ARG_Ent = self.WeaponEnt
			ARG_Ent = ARG_Ent:GetPhysicsObject()
			self:SetConstraintState("aim")
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"arg_weapon_m4a1(aim)",1)
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_m4a1(aim-hands)",1)
			--ARG_Tilt = 50
			--BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"arg-weapon_knife(corrective_atkdir)",1)
			--self:Animate(1)
			--print(CurTime())
		else
			if(!BSF_RAGDOLLCONTROL_ANIMATION:IsAnimating(rag,"weapon_m4a1(reload)"))then
				BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,"weapon_ak(idle)",1)
			end
		end
		if(IsChanged(ply:KeyDown(IN_ATTACK2),"KeyDown_IN_ATTACK2",self) and !ply:KeyDown(IN_ATTACK2))then
			if(!self.Reloading)then
				self:SetConstraintState("normal")
			end
		end
		
		if(self.NextShoot and self.NextShoot<=CurTime())then
			self.NextShoot = nil
		end
		
		if(!self.Reloading)then
			if(ply:KeyDown(IN_ATTACK))then
				if(ply:KeyDown(IN_ATTACK2) and !self.NextShoot)then
					self.NextShoot = CurTime() + self.ShootCD
					self:TryShoot()
				elseif(!ply:KeyDown(IN_ATTACK2) and !self.NextAttack and BSF_RAGDOLLCONTROL:GetKeyDown(ply,IN_ATTACK))then
					self:Animate("weapon_ak(stab)")
				end
			end
		end

		self:AnimThink()	--Everything better postbodyanims
	end
end

SWEP["AutoHook_BSF_PHYSCONTROL(PhysicsCollide)"] = function(self,ent,data)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	local b_handR = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	-- or (ent == rag and data.PhysObject==b_handR)
	if( ((ent==self.WeaponEnt and data.HitEntity!=rag) or (ent == rag and data.PhysObject==b_handR) ) and BSF_RAGDOLLCONTROL_WEAPONS:IsTargetSoft(data.HitEntity))then	--Making sure we can't harm ourselves(We can't possibly actually> Why? Because Garry's)
		if((self:IsAttackingAny()) and !self.DealtDamage)then
			speed = data.HitSpeed:Length()
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
				
				rag:EmitSound("physics/body/body_medium_impact_hard1.wav",math.max(frac*80,50))
				self.DealtDamage = true
			end
			self.DealtDamage = true
		end
	end
end
//AutoHooks

SWEP.WeaponConstraintStates = {
	["normal"] = function(self)
		self:CreateWeaponEnt()
		
		self:UnWeldWeaponEnt()
		self:PositionWeaponEnt()
		self:WeldWeaponEnt()
		
		self:UnWeldWeaponLHandEnt()
		self:PositionHand()
		self:WeldWeaponLHandEnt()
	end,
	["reload"] = function(self)
		self:CreateWeaponEnt()
	
		self:UnWeldWeaponEnt()
		self:PositionWeaponEnt()
		self:WeldWeaponEnt()
	end,
	["aim"] = function(self)
		self:UnWeldWeaponEnt()
		self:UnWeldWeaponLHandEnt()
	end,
}

table.Merge(SWEP,{	--Easy way of creating rest of the SWEP from legacy BSF SWEP system
	GetLeftHandPos = function(self)
		return self.WeaponEnt:GetPos()+self.WeaponEnt:GetAngles():Right()*0+self.WeaponEnt:GetAngles():Up()*2.5+self.WeaponEnt:GetAngles():Forward()*-2
	end,

	GetLeftHandAng = function(self)
		local angs = self.WeaponEnt:GetAngles()
		angs:RotateAroundAxis(angs:Forward(),-90)
		--angs:RotateAroundAxis(angs:Up(),-90)
		return angs
	end,
	
	PositionHand = function(self,up)
		if(CLIENT)then return end
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		up = up or 0
		local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
		b_handL:SetPos(self:GetLeftHandPos()+self.WeaponEnt:GetAngles():Right()*up)
		b_handL:SetAngles(self:GetLeftHandAng())
	end,
	
	RemoveWeaponEnt = function(self)
		if(CLIENT)then return end
		local wep = self.WeaponEnt
		if(IsValid(wep))then
			wep:Remove()
		end
	end,
	
	PositionWeaponEnt = function(self)
		if(CLIENT)then return end
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		local wep = self.WeaponEnt
		local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
		local handangs = b_hand:GetAngles()
		local handangs = b_hand:GetAngles()
		handangs:RotateAroundAxis(handangs:Forward(),180)
		handangs:RotateAroundAxis(handangs:Right(),0)
		--handangs:RotateAroundAxis(handangs:Up(),180)
		wep:SetPos(b_hand:GetPos()+b_hand:GetAngles():Forward()*13+b_hand:GetAngles():Right()*1.5+b_hand:GetAngles():Up()*2)
		wep:SetAngles(handangs)
	end,
	
	WeldWeaponLHandEnt = function(self)
		if(CLIENT)then return end
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		local wep = self.WeaponEnt
		local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
		local locvec = self:GetLeftHandPos()
		locvec = locvec + b_handL:GetAngles():Forward()*4 + b_handL:GetAngles():Up()*-1 + b_handL:GetAngles():Right()*1
		--locvec = b_handL:WorldToLocal(locvec)
		self.WeaponLHANDWeld = constraint.Ballsocket(wep,rag,0,rag._PhysToBonesNum[b_handL],b_handL:WorldToLocal(locvec),0,0)--constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_handL],0,false,false)
	end,

	UnWeldWeaponLHandEnt = function(self)
		if(CLIENT)then return end
		local wep = self.WeaponEnt
		if(IsValid(self.WeaponLHANDWeld))then
			self.WeaponLHANDWeld:Remove()
		end
	end,

	UnWeldWeaponEnt = function(self)
		if(CLIENT)then return end
		local wep = self.WeaponEnt
		constraint.RemoveConstraints(wep,"Weld")
		--constraint.RemoveConstraints(wep,"Weld")
	end,
	
	WeldWeaponEnt = function(self)
		if(CLIENT)then return end
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		local wep = self.WeaponEnt
		local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
		constraint.Weld(wep,rag,0,rag._PhysToBonesNum[b_hand],0,false,false)
	end,
	
	CreateWeaponEnt = function(self)
		--if(1)then return end
		if(CLIENT)then return end
		if(IsValid(self.WeaponEnt))then self.WeaponEnt:Remove() end
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		if(!IsValid(rag))then return end
		
		local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
		local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
		
		self.WeaponEnt = ents.Create("prop_physics")
		local wep = self.WeaponEnt
		wep.BSF_PreventUse = true
		self:SetWeaponEnt(wep)
		
		--wep:SetModel("models/weapons/w_rif_famas.mdl")
		wep:SetModel("models/weapons/w_rif_m4a1.mdl")
		--self:PositionWeaponEnt(wep)
		BSF_PHYSCONTROL:AddPhysCollideCallBack(wep)
		wep:Spawn()
		wep:Activate()
		
		wep:GetPhysicsObject():SetMass(1)
		wep:GetPhysicsObject():SetDragCoefficient(0)
		constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_hand])
		constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_handL])
		--[[
		self:WeldWeaponEnt()
		
		self:PositionHand(0)
		self:WeldWeaponLHandEnt()
		]]
	end,
	
	StopAttacks = function(self)
		self.AttackingTable = {}
	end,
	StopOneTimeAnims = function(self)
		local ply = self:GetOwner()
		if(SERVER and IsValid(ply) and IsValid(ply.BSF_Ragdoll))then
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(ply.BSF_Ragdoll,"weapon_m4a1(reload)")
		end
	end,
	
	Deploy = function(self)
		self:CreateWeaponEnt()
		self:UnWeldWeaponEnt()
		self:PositionWeaponEnt()
		self:WeldWeaponEnt()
		
		self:UnWeldWeaponLHandEnt()
		self:PositionHand()
		self:WeldWeaponLHandEnt()
	end,
	
	Holster = function(self,swtichto)
		self:StopAttacks()
		self:RemoveWeaponEnt()
		self:StopReload()
		self:StopOneTimeAnims()
		return true
	end,
	
	OnRemove = function(self)
		self:StopAttacks()
		self:RemoveWeaponEnt()
		self:StopReload()
		self:StopOneTimeAnims()
	end,
	
	Think = function(self)
		if(SERVER)then	--Only execute on server
			local ply = self.Owner
			local rag = ply.BSF_Ragdoll
			
			if(self.NextAttack and self.NextAttack<=CurTime())then
				self.NextAttack = nil
			end
			
			self:AddRecoilMul(engine.TickInterval()*self.RecoilAddPerSecond)
			--print(self:GetRecoilMul())
			--Nothing to see here, everything proccessed post body animation
			
		end
		self:ReloadThink()
	end,
	
	RecoilAddPerSecond = 2,
	MaxRecoil = 1.3,
	AddRecoilMul = function(self,amt)
		self.RecoilMul = math.Clamp((self.RecoilMul or 1)+amt,1,self.MaxRecoil)
	end,
	GetRecoilMul = function(self)
		self.RecoilMul = self.RecoilMul or 1
		return self.RecoilMul
	end,
	
	ShootEffects = function(self)
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		local angs = self.WeaponEnt:GetAngles()
		local phys = self.WeaponEnt:GetPhysicsObject()
		local recoilmul = 1.3*self:GetRecoilMul()
		phys:ApplyForceCenter(angs:Up()*1-angs:Forward()*40)
		phys:ApplyTorqueCenter(angs:Up()*math.Rand(-0.3,0.3)*4*recoilmul)
		phys:ApplyTorqueCenter(-angs:Right()*math.Rand(-0.5,-0.3)*7*recoilmul)
		
		self:Recoil(Angle(-recoilmul*math.Rand(0.3,0.5)/1.8,-recoilmul/1.5*math.Rand(-0.3,0.4),0),Angle(-recoilmul/1.8*math.Rand(0.3,0.5),-recoilmul/1.5*math.Rand(-0.1,0.2),0))
		
		self.WeaponEnt:EmitSound("weapons/m4a1/m4a1-1-single.wav",75,100,1,CHAN_WEAPON)
		
		--self:AddRecoilMul(-0.1)
		self:AddRecoilMul(-2*self.ShootCD)
	end,
	
	PostReload = function(self)
		self:SetConstraintState("normal")
	end,
	
	ReloadTime = 2.3,
	Reload = function(self)
		--if(SERVER)then
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		if(self:Clip1()<self:GetMaxClip1() and ply:GetAmmoCount( self:GetPrimaryAmmoType() )>0 and !self.Reloading)then
			self.Reloading = CurTime()+self.ReloadTime
			--self:Animate("weapon_ak(reload)",true,true)
			if(SERVER)then
				BSF_RAGDOLLCONTROL_ANIMATION:ResetAnimation(rag,"weapon_m4a1(reload)")
				self:SetConstraintState("reload")
				self.WeaponEnt:EmitSound("weapons/ar2/ar2_reload.wav",55,100,1,CHAN_AUTO)
			end
		end
		--end
	end,
	
	ReloadThink = function(self)
		if(self.Reloading and self.Reloading<=CurTime())then
			self:EndReload()
			self:StopReload()
		end
	end,
	
	EndReload = function(self)
		local ply = self.Owner
		local delta = math.min(ply:GetAmmoCount( self:GetPrimaryAmmoType() ),math.max(self:GetMaxClip1()-self:Clip1(),0))
		self:SetClip1(self:Clip1()+delta)
		ply:RemoveAmmo(delta,self:GetPrimaryAmmoType())
		self:PostReload()
	end,

	StopReload = function(self)
		self.Reloading = nil
	end,

	TryShoot = function(self)
		if(self:Clip1()<1 or self.Reloading)then
			return
		end
		self:SetClip1(self:Clip1()-1)
		
		self:Shoot()
	end,
	
	Shoot = function(self)
		local angs = self.WeaponEnt:GetAngles()
		local bul = {}
		bul.Attacker = self
		bul.Damage = self.ShootDamage
		bul.Force = self.ShootForce
		bul.Dir = angs:Forward()--self.Owner:GetAimVector()
		bul.Src = self.WeaponEnt:GetPos()+angs:Up()*7+angs:Forward()*13
		local spread = 0.001 --* self:GetRecoilMul()
		bul.Spread = Vector(spread,spread,0)
		bul.TracerName = "Tracer"
		bul.IgnoreEntity = self.WeaponEnt
		
		bul.Attacker = self.Owner
		
		self.WeaponEnt:FireBullets(bul)
		
		self:ShootEffects()
	end,
})
--}
--BSF_RAGDOLLCONTROL_WEAPONS:ReloadAllWeaponScripts(self.Class)
