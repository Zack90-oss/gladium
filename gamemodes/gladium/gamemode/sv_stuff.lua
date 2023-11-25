ATK_SLASH=0.9
ATK_STAB=1.4


--NAME : SWORDS_InterestAnims
--This is the list of wOS holdype id's
--All animations, identified with the corresponding id will be sent to a new player or anyone you want
--METHOD : Add things here like that > SWORDS_InterestAnims[holdtypeid]=true
--//Fixes animation differentiation  between server and client\\
SWORDS_InterestAnims={
	["swrd-battleaxe"]=true,
	["swrd-halberd"]=true,
	["swrd-sword"]=true,
}

SWORDS_ModelStats={
	["models/aoc_playermodels/aoc_peasant.mdl"]={
		[HITGROUP_HEAD]={
			HitSound = "Flesh.BulletImpact",
			Absorption=-20,
			ShockAbsorption=-20,
			MinDamage=0,
			MinShock=0,
			ClubDamageAdd=0,
			ClubShockAdd=0,
		},
		[HITGROUP_CHEST]={
			HitSound = "Flesh.BulletImpact",
			Absorption=-10,
			ShockAbsorption=-20,
			MinDamage=0,
			MinShock=0,
			ClubDamageAdd=0,
			ClubShockAdd=0,
		},
		[HITGROUP_STOMACH]={
			HitSound = "Flesh.BulletImpact",
			Absorption=-10,
			ShockAbsorption=-20,
			MinDamage=0,
			MinShock=0,
			ClubDamageAdd=0,
			ClubShockAdd=0,
		},
		[HITGROUP_LEFTARM]={
			HitSound = "Flesh.BulletImpact",
			Absorption=-10,
			ShockAbsorption=-20,
			MinDamage=0,
			MinShock=0,
			ClubDamageAdd=0,
			ClubShockAdd=0,
		},
		[HITGROUP_LEFTLEG]={
			HitSound = "Flesh.BulletImpact",
			Absorption=-10,
			ShockAbsorption=-20,
			MinDamage=0,
			MinShock=0,
			ClubDamageAdd=0,
			ClubShockAdd=0,
		},
	},
	["models/aoc_playermodels/aoc_g_knight.mdl"]={
	},
	["models/aoc_playermodels/aoc_g_footman.mdl"]={
		[HITGROUP_HEAD]={
			HitSound = "Metal_Box.BulletImpact",
			Absorption=45,
			ShockAbsorption=20,
			MinDamage=10,
			MinShock=10,
			ClubDamageAdd=35,
			ClubShockAdd=25,
		},
		[HITGROUP_CHEST]={
			HitSound = "physics/metal/metal_barrel_sand_impact_bullet2.wav",
			Absorption=30,
			ShockAbsorption=10,
			MinDamage=10,
			MinShock=10,
			ClubDamageAdd=5,
			ClubShockAdd=5,
		},
		[HITGROUP_STOMACH]={
			HitSound = "physics/metal/metal_barrel_sand_impact_bullet2.wav",
			Absorption=30,
			ShockAbsorption=10,
			MinDamage=10,
			MinShock=10,
			ClubDamageAdd=5,
			ClubShockAdd=5,
		},
		[HITGROUP_LEFTARM]={
			HitSound = "Metal_Box.BulletImpact",
			Absorption=30,
			ShockAbsorption=10,
			MinDamage=10,
			MinShock=10,
			ClubDamageAdd=20,
			ClubShockAdd=5,
		},
		[HITGROUP_LEFTLEG]={
			HitSound = "physics/metal/metal_barrel_sand_impact_bullet2.wav",
			Absorption=30,
			ShockAbsorption=10,
			MinDamage=10,
			MinShock=10,
			ClubDamageAdd=20,
			ClubShockAdd=5,
		},
	},
	["models/aoc_playermodels/aoc_g_archer.mdl"]={
	},
	
	["models/aoc_playermodels/aoc_e_knight.mdl"]={
	},
	["models/aoc_playermodels/aoc_e_footman.mdl"]={
	},
	["models/aoc_playermodels/aoc_e_archer.mdl"]={
	},
}