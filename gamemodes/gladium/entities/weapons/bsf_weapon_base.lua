--Brutal Sword Fight weapon base--
SWEP.PrintName		= "--"
SWEP.Instructions	= "--"
if(CLIENT)then
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_smallpistol")
	SWEP.BounceWeaponIcon=false
end
SWEP.ViewModelFOV	= 62
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.RenderGroup = RENDERGROUP_OTHER	--Source WorldModel should be invisible

SWEP.Spawnable		= false		--GMOD, Is this Q-menu spawnable?
SWEP.AdminOnly		= false		--GMOD, only admons can spawn this from Q-menu?

SWEP.Primary.ClipSize		= 0			-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"	-- Your ammo type for this weapon (ar2,smg1,pistol,buckshot etc.)

--Stop giving ammo--
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
--				  --

--\\Meleeing
SWEP.Damage = 15				--Maximum amount of damage; Calculated later math.min(speed/self.TerminalSpeed,1)*self.Damage

SWEP.TerminalSpeed = 110		--Melee Speed to deal maximum amount of damage
SWEP.AttackCD = 0.3				--Melee Attack CoolDown
SWEP.AttackCDStab = 0.4			--Melee Attack CoolDown for stab attack type; Processed by default then (stab) animation is playing

SWEP.PostAnimDamageTime = 0.1	--Time for damage left after anim ends
--//

--\\Shooting
SWEP.ShootDamage = 45			--Damage dealt by bullets
SWEP.ShootForce = 6				--Force applied to the object hit by the bullet from this weapon
SWEP.ShootCD = 60/900			--CoolDown after each shot before another; to type in RPM -> 60/RPM
--//

--\\Reload
SWEP.ReloadTime = 2.3			--Time to reload the (gun)
--//

--\\Recoil
SWEP.ConstantRecoilMul = 1.0	--StaticRecoilFactor; Constant multiplier of recoil
SWEP.RecoilAddPerShot = -2		--Recoil added per shot; Yep, continuous fire decreases felt recoil

SWEP.RecoilAddPerSecond = 2		--Recoil added per second(even while shooting)
SWEP.MaxRecoil = 1.3			--Maximum recoil multiplier you can achieve by shooting continuously

SWEP.ForceRecoil = {			--Physical recoil weapon entity experiences; Note that recoilmul variable will only target angular force by default
	Linear = {
		Up 		= {1,1},
		Forward = {-40,-40},
		Right 	= {0,0},
	},
	Angular = {
		Up 		= {-1.2,1.2},	--Sideways from player's perspective
		Forward = {0,0},		--Roll from player's perspective
		Right 	= {2.1,3.5},	--Kick up from player's perspective
	},
}
--//

--\\BulletInfo merge table >>has PRIORITY over other bullet variables<<
SWEP.BulletInfo = {				--Will be merged with BulletInfo before firing
	Damage = 10,
	Force = 10,
}
--//

--\\Sounds
SWEP.HitSounds = {				--Sounds upon Melee hit
	["weapons/knife/knife_hit1.wav"] = {FracMul = 80, VolumeMax = 50},	--Sound as the key, Emit info as the value
}
SWEP.ShootSounds = {			--(gun) fire sounds
	"weapons/ak47/ak47-1.wav",
}
SWEP.ReloadSounds = {			--(gun) reload sounds
	"weapons/ar2/ar2_reload.wav",
}
--//

--\\Constraint State					--;You are getting into the dark forest now mate...
--	Constraint State System, is a system, what is.. blah blah blah(It basically just re-creates(or not) entity with new constraints)
--	Below are 3 main states for weapon
SWEP.ConstraintStateReload = "reload"	--When we are reloading the weapon
SWEP.ConstraintStateNormal = "normal"	--When we are not doing anything with the weapon
SWEP.ConstraintStateAim = "aim"			--When we are aiming the weapon(soon will be deprecated I hope)

SWEP.WeaponConstraintStates = {
	["normal"] = function(self)
		self:CreateWeaponEnt()			--Re-Create Weapon Entity; Removes the old one and creates a new one, because we can't just remove some constraints and apply new one in one tick(Source)
		self:PositionWeaponEnt()		--Position weapon ent in the hand(propably)
		self:WeldWeaponEnt()			--Weld weapon to hand
	end,								--This can be expanded, more functions added or tweaked to your liking
	["aim"] = function(self)
		self:UnWeldWeaponEnt()
	end,
	
	["reload"] = function(self)
		self:CreateWeaponEnt()
		self:PositionWeaponEnt()
		self:WeldWeaponEnt()
	end,
},
--//

--\\Animations
SWEP.MainAnimation = "weapon_ak"		--Will be called with ..(suffix) or be used in other way if animation function is overriden
SWEP.AnimationArgumentPrefix = "arg-"
SWEP.AnimationSuffixes = {
	["reload"] = "(reload)",
	["idle"] = "(idle)",
	["stab"] = "(stab)",
	["corrective_atkdir"] = "(corrective_atkdir)",
	
	["slash-left"] = "(slash-left)",
	["slash-right"] = "(slash-right)",
}
--//

--AutoHook Table
--METHOD: Will add hooks to weapons copies and call similar function (WITH PREFIX "AutoHook_") in that copy then time comes
SWEP.AutoHooks = {
	"BSF_RAGDOLLCONTROL(PostBodyAnimation)",	--Will add this hook and run self.AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation) then needed
	"BSF_PHYSCONTROL(PhysicsCollide)",
}

SWEP.BSF = true							--Is this weapon Brutal Sword Fight related?; This thing is for detection by gamemode

function SWEP:AdditiveSetupDataTables()
	--override
end


function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "WeaponEnt" )
	self:AdditiveSetupDataTables()
end

function SWEP:AutoHooksCreate()
	if(self.AutoHooks)then
		for id,hok in pairs(self.AutoHooks)do
			if(id!="BaseClass")then	--Stopping the BaseClass form initializing
				--local strippedhok = string.gsub(hok,"[(){}/.%[%] ]","")
				hook.Add(hok,self,self["AutoHook_"..hok])
			end
		end
	end
end

SWEP.Initialize = function(self)
	self:AutoHooksCreate()
end

function SWEP:Recoil(punch,eyerecoil)
	local ply = self:GetOwner()
	ply:ViewPunch(punch)
	BSF_RAGDOLLCONTROL_WEAPONS:Recoil(ply,eyerecoil)
end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end

--\\AutoHooks
SWEP["AutoHook_BSF_RAGDOLLCONTROL(PostBodyAnimation)"] = function(self,comrag,eyeangs,footbase,additiveeyeangs)
	local ply = self.Owner
	if(!IsValid(ply) or !IsValid(ply:GetActiveWeapon()))then return nil end
	local rag = ply.BSF_Ragdoll
	if(comrag == rag and ply:GetActiveWeapon():GetClass()==self:GetClass())then --We want to animate only after our ragdoll body anim not any other
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,self:GetFullAnimationName(self.AnimationSuffixes["idle"]),1)
		self:AnimThink()	--Everything better postbodyanims
		
		local atkdir = nil
		if(self:IsAttacking(self:GetFullAnimationName(self.AnimationSuffixes["stab"])))then
			atkdir = (atkdir or 0) + 40
		end
		
		if(atkdir)then
			ARG_Tilt = atkdir	--Needed animation argument
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,self.AnimationArgumentPrefix..self:GetFullAnimationName(self.AnimationSuffixes["stab"]),1)
		end
	end
end

SWEP["AutoHook_BSF_PHYSCONTROL(PhysicsCollide)"] = function(self,ent,data)
	local ply = self.Owner
	local rag = ply.BSF_Ragdoll
	--local b_handR = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	if(((ent==self.WeaponEnt and data.HitEntity!=rag) ))then	--Making sure we can't harm ourselves(We can't possibly actually> Why? Because Garry's)
		if((self:IsAttackingAny()))then
			if(BSF_RAGDOLLCONTROL_WEAPONS:IsTargetSoft(data.HitEntity))then
				self:ApplyPhysHitDamage()
			end
		end
	end
end
--//

function SWEP:HitEffects(data,rag,frac)
	SWEP:PlayHitSound(data,rag)
	local effectdata = EffectData()
	effectdata:SetOrigin( data.HitPos )
	util.Effect( "BloodImpact", effectdata )
end

function SWEP:PlayHitSound(data,rag,frac)
	local info,sound = table.Random(self.HitSounds)
	rag:EmitSound(sound,math.max(frac*info.FracMul,info.VolumeMax))
end

function SWEP:ApplyPhysHitDamage(data)
	self.DealtDamage = self.DealtDamage or {}
	if(!self.DealtDamage[data.HitEntity])then
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
				BSF_RAGDOLLCONTROL:ApplyDamage(data.HitEntity,dmg,data.HitObject,self)
				
				SWEP:HitEffects(data,rag,frac)
			self.DealtDamage[data.HitEntity] = (self.DealtDamage[data.HitEntity] or 0) + 1
		end
	end
end

SWEP.GetCurAttackDmgMul = function(self)
	self.AttackingTable = self.AttackingTable or {}
	local mul = 1
	for mode,atk in pairs(self.AttackingTable)do
		mul = mul*(self.AttackDamageMuls[mode] or 1)
	end
	return mul
end

table.Merge(SWEP,{
-->>Holster, Deploy, OnRemove etc.
	Deploy = function(self)
		self:SetConstraintState(self.ConstraintStateNormal)
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
--<<

-->>Constraint States
	SetConstraintState = function(self,state)
		self.WeaponConstraintStates[state](self)
	end,
--<<	

-->>Animations and attacks
	GetFullAnimationName = function(self,suffix)
		return self.MainAnimation..suffix
	end,

	StopAttacks = function(self)
		if(self.AnimationTable)then
			for id,info in pairs(self.AnimationTable)do
				self.AnimationTable[id].NoAttack = true
			end
		end
	end,
	
	StopOneTimeAnims = function(self)
		local ply = self:GetOwner()
		if(SERVER and IsValid(ply) and IsValid(ply.BSF_Ragdoll))then
			BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(ply.BSF_Ragdoll,self:GetFullAnimationName(self.AnimationSuffixes["reload"]))
		end
	end,
	
	PreAnimThinkItem = function(self,info)
		--return false to disable default logic and post
	end,
	
	PostAnimThinkItem = function(self,info)
		if(info.DamageStartTime and info.DamageStartTime<=CurTime())then
			info.DamageStartTime = nil
			info.Attacking = true
		end
	end,

	AnimThink = function(self)
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		self.AnimationTable = self.AnimationTable or {}
		
		for id,info in pairs(self.AnimationTable)do
			if(self:PreAnimThinkItem(info)!=false)then
				if(info.EndTime<=CurTime())then
					self.AnimationTable[id] = nil
					self.DealtDamage = {}	--Table with dealt damage	--ЛОМАЕТ СТАРОЕ
				elseif(info.AnimEndTime>CurTime())then
					BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,info.Anim,info.Rate)
				end
				self:PostAnimThinkItem(info)
			end
		end
	end,

	IsAttacking = function(self,atkid)
		self.AnimationTable = self.AnimationTable or {}
		return self.AnimationTable[atkid]~=nil and self.AnimationTable[atkid].Attacking
	end,
	
	IsAnimating = function(self,atkid)
		self.AnimationTable = self.AnimationTable or {}
		return (self.AnimationTable[atkid] and self.AnimationTable[atkid].AnimEndTime>CurTime())
	end,

	IsAttackingAny = function(self)
		self.AnimationTable = self.AnimationTable or {}
		for mode,info in pairs(self.AnimationTable)do
			if(info.Attacking)then
				return true
			end
		end
		return false
	end,
	
	Animate = function(self,mode,noattackcd,noattack)
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		
		self.AnimationTable = self.AnimationTable or {}
		self.AnimationTable[mode] = {}
		local atk = self.AnimationTable[mode]
		atk.Anim = mode
		atk.Rate = 1
		atk.AnimEndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)
		atk.EndTime = CurTime()+BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,mode)+self.PostAnimDamageTime
		atk.NoAttack = noattack
		if(!noattackcd)then
			self:CalculateNextAttack(mode,atk)
			self:StartAttack(self,atk,noattackcd,noattack)
		end
		
		self.DealtDamage = {}
		
		hook.Run("BSF_WEAPONS_ANIMATIONSTARTED",self,atk)
		return atk.AnimEndTime
	end,
	
	StartAttack = function(self,atk,noattackcd,noattack)
		if(self.AttackDamageStarts[mode])then
			atk.DamageStartTime = CurTime()+self.AttackDamageStarts[mode]
		end
	end,
--<<
	
-->>AttackCD
	CalculateNextAttack = function(self,mode,atk)
		if(mode==self:GetFullAnimationName(self.AnimationSuffixes["stab"]))then
			self.NextAttack = atk.EndTime+self.AttackCDStab
		else
			self.NextAttack = atk.EndTime+self.AttackCD
		end
	end,
--<<
	
-->>Reload related
	PostReload = function(self)
		self:SetConstraintState(self.ConstraintStateNormal)
	end,
	
	Reload = function(self)
		--if(SERVER)then
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		if(self:Clip1()<self:GetMaxClip1() and ply:GetAmmoCount( self:GetPrimaryAmmoType() )>0 and !self.Reloading)then
			self.Reloading = CurTime()+self.ReloadTime
			--self:Animate("weapon_ak(reload)",true,true)
			if(SERVER)then
				BSF_RAGDOLLCONTROL_ANIMATION:ResetAnimation(rag,self:GetFullAnimationName(self.AnimationSuffixes["reload"]))
				self:SetConstraintState(self.ConstraintStateReload)
				self:PlayReloadSound()
			end
		end
		--end
	end,
	
	ReloadThink = function(self)
		if(self.Reloading and self.Reloading<=CurTime())then
			self:EndReload()
			self:StopReload()--Че.?
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
--<<
	
-->>Bullet modifiers
	CalculateBulletDir = function(self,angs)
		return angs:Forward()
	end,
	CalculateBulletSrc = function(self,pos,angs)
		return (self.WeaponEnt:GetPos()+angs:Up()*7+angs:Forward()*13)
	end,
	CalculateBulletSpread = function(self,spread)
		return Vector(spread,spread,0)
	end,
--<<

-->>Custom recoil
	ApplyForceRecoil = function(self,phys,angs,recoilmul)
		local linear = self.ForceRecoil.Linear
		local angular = self.ForceRecoil.Angular
		
		phys:ApplyForceCenter(angs:Up()*math.Rand(linear.Up[1],linear.Up[2]) + angs:Forward()*math.Rand(linear.Forward[1],linear.Forward[2]) + angs:Right()*math.Rand(angular.Right[1],angular.Right[2]))
		phys:ApplyTorqueCenter(angs:Up()*math.Rand(angular.Up[1],angular.Up[2]) + angs:Forward()*math.Rand(angular.Forward[1],angular.Forward[2]) + angs:Right()*math.Rand(angular.Right[1],angular.Right[2]) * recoilmul)
	end,
	
	CalculateFinalRecoil = function(self,phys,angs,recoilmul)
		return Angle(-recoilmul*math.Rand(0.3,0.5)/1.8,-recoilmul/1.5*math.Rand(-0.3,0.4),0),Angle(-recoilmul/1.8*math.Rand(0.3,0.5),-recoilmul/1.5*math.Rand(-0.1,0.2),0)
	end,
	
	AddRecoilMul = function(self,amt)
		self.RecoilMul = math.Clamp((self.RecoilMul or 1)+amt,1,self.MaxRecoil)
	end,
	GetRecoilMul = function(self)
		self.RecoilMul = self.RecoilMul or 1
		return self.RecoilMul
	end,
--<<

-->>Custom Sounds
	PlayShootSound = function(self,recoilmul)
		self.WeaponEnt:EmitSound(table.Random(self.ShootSounds),75,100,1,CHAN_WEAPON)
	end,
	
	PlayReloadSound = function(self,recoilmul)
		self.WeaponEnt:EmitSound(table.Random(self.ReloadSounds),55,100,1,CHAN_AUTO)
	end,
--<<
	
-->>Shooting related
	ShootEffects = function(self)
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		local angs = self.WeaponEnt:GetAngles()
		local phys = self.WeaponEnt:GetPhysicsObject()
		local recoilmul = self.ConstantRecoilMul*self:GetRecoilMul()
		self:ApplyForceRecoil(phys,angs,recoilmul)
		
		self:Recoil(self:CalculateFinalRecoil(phys,angs,recoilmul))	--This one is mandatory
		
		self:PlayShootSound(recoilmul)
		
		self:AddRecoilMul(self.RecoilAddPerShot*self.ShootCD)
	end,

	Shoot = function(self)
		local angs = self.WeaponEnt:GetAngles()
		local bul = {}
		bul.Attacker = self
		bul.Damage = self.ShootDamage
		bul.Force = self.ShootForce
		bul.Dir = (self.CalculateBulletDir and self:CalculateBulletDir(angs)) or angs:Forward()
		bul.Src = (self.CalculateBulletSrc and self:CalculateBulletSrc(self.WeaponEnt:GetPos(),angs)) or (self.WeaponEnt:GetPos()+angs:Up()*7+angs:Forward()*13)
		local spread = self.BulletSpread or 0.001 --* self:GetRecoilMul()
		bul.Spread = (self.CalculateBulletSpread and self:CalculateBulletSpread(spread)) or Vector(spread,spread,0)
		bul.TracerName = self.BulletTracer or "Tracer"
		bul.IgnoreEntity = self.WeaponEnt
		
		table.Merge(bul,self.BulletInfo)
		
		bul.Attacker = self.Owner
		
		self.WeaponEnt:FireBullets(bul)
		
		self:ShootEffects()
	end,
	
	TryShoot = function(self)
		if(self:Clip1()<1 or self.Reloading)then
			return
		end
		self:SetClip1(self:Clip1()-1)
		
		self:Shoot()
	end,
--<<

-->>Weapon ENT Creation
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
		if(CLIENT)then return end
		if(IsValid(self.WeaponEnt))then self.WeaponEnt:Remove() end
		local ply = self.Owner
		local rag = ply.BSF_Ragdoll
		if(!IsValid(rag))then return end
		
		self.WeaponEnt = ents.Create("prop_physics")
		local wep = self.WeaponEnt
		wep.BSF_PreventUse = true
		self:SetWeaponEnt(wep)
		
		wep:SetModel(self.WeaponModel or "models/weapons/w_pist_usp.mdl")
		
		--constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_hand])
		BSF_PHYSCONTROL:AddPhysCollideCallBack(wep)
		wep:Spawn()
		wep:Activate()

		wep:GetPhysicsObject():SetMass(1)
		wep:GetPhysicsObject():SetDragCoefficient(0)
		local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
		local b_handL = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
		constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_hand])
		constraint.NoCollide(wep,rag,0,rag._PhysToBonesNum[b_handL])
		--self:PositionWeaponEnt(wep)

		return wep
	end,
--<<

-->>Think
	Think = function(self)
		if(SERVER)then	--Only execute on server
			local ply = self.Owner
			local rag = ply.BSF_Ragdoll
			
			if(self.NextAttack and self.NextAttack<=CurTime())then
				self.NextAttack = nil
			end
			
			self:ReloadThink()
			--Nothing to see here, everything proccessed post body animation
		end
	end,
--<<
})

--\\Attack muls
SWEP.AttackDamageMuls = {
	[SWEP:GetFullAnimationName(SWEP.AnimationSuffixes["stab"])]=0.7,
}
SWEP.AttackDamageStarts = {--ДОРАБОТАТЬ
	[SWEP:GetFullAnimationName(SWEP.AnimationSuffixes["slash-right"])]=0.2,
	[SWEP:GetFullAnimationName(SWEP.AnimationSuffixes["slash-left"])]=0.2,
}
--//