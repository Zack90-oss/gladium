--First Weapon to rely solely on base, see most needed >examples here<
AddCSLuaFile()
SWEP.Base = "bsf_weapon_base"
SWEP.PrintName = "FAMAS F1"
SWEP.Instructions = "Famas"

SWEP.Slot = 0
SWEP.SlotPos = 2

SWEP.Damage = 15

SWEP.ShootDamage = 45
SWEP.ShootForce = 6

SWEP.TerminalSpeed = 110
SWEP.AttackCD = 0.3
SWEP.AttackCDStab = 0.4

SWEP.ShootCD = 60/900

SWEP.PostAnimDamageTime = 0.1

SWEP.Primary.ClipSize		= 30		-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "smg1"

SWEP.WeaponModel = Model("models/weapons/w_rif_famas.mdl")

SWEP.ForceRecoil = {			--Physical recoil weapon entity experiences; Note that recoilmul variable will only target angular force by default
	Linear = {
		Up 		= {1,1},
		Forward = {-20,-20},
		Right 	= {0,0},
	},
	Angular = {
		Up 		= {-0.5,0.5},	--Sideways from player's perspective
		Forward = {0,0},		--Roll from player's perspective
		Right 	= {1.1,1.6},	--Kick up from player's perspective
	},
}

SWEP.WeaponConstraintStates = {	--This here is one of the trickiest parts
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