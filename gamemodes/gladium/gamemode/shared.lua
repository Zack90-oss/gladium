
GM.Name = "Brutal Sword Fight[BSF]"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

function BSF_UTILS_SetMaxClip1(wep)
	wep:SetClip1(wep:GetMaxClip1())
end

AddCSLuaFile( "weighted_random.lua" )
include( "weighted_random.lua" )

AddCSLuaFile( "translation.lua" )
include( "translation.lua" )

AddCSLuaFile( "value.lua" )
include( "value.lua" )

AddCSLuaFile( "sh_anims.lua" )
include( "sh_anims.lua" )

AddCSLuaFile( "sh_ragdoll_weapons.lua" )	--SHARED FILE!
include( "sh_ragdoll_weapons.lua" )	--SHARED FILE!

AddCSLuaFile( "sh_gamemodes.lua" )
include( "sh_gamemodes.lua" )

AddCSLuaFile( "sh_maps.lua" )
include( "sh_maps.lua" )

AddCSLuaFile( "sh_game.lua" )
include( "sh_game.lua" )

--Ragdoll
--[[
AddCSLuaFile( "sh_ragdoll_control.lua" )
include( "sh_ragdoll_control.lua" )

AddCSLuaFile( "sh_ragdoll_animation.lua" )
include( "sh_ragdoll_animation.lua" )

AddCSLuaFile( "sh_ragdoll_weapons.lua" )
include( "sh_ragdoll_weapons.lua" )]]

function GM:PlayerSpawn(ply)
	if(!BSF_GAME:CanSpawn(ply))then
		return
	end
	if(!_BSF_DontSetPlayerModel)then
		hook.Run( "PlayerSetModel", ply )
	end
	_BSF_DontSetPlayerModel = nil
	if(SERVER)then
		if(!_BSF_DontCreateRag)then
			ply.BSF_Team = nil
			local rag = GAMEMODE:SetupRagdoll(ply)
			BSF_RAGDOLLCONTROL:SpectateRagdoll(ply,rag)
			
			if(math.random(1,2)==1)then
				rag:SetColor(Color(255,0,0))
			elseif(math.random(1,6)==1)then
				rag:SetColor(Color(0,255,0))
			else
				rag:SetColor(Color(0,0,255))
			end
			
			ply:Give("gweapon_fists")
			--if(math.random(1,4)==1)then
			--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_stunstick')
			--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_knife')
			if(math.random(1,4)==1)then
				BSF_UTILS_SetMaxClip1(ply:Give("gweapon_pistol"))
				ply:GiveAmmo(60,"pistol")
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_pistol')
			end
			if(math.random(1,4)==1)then
				BSF_UTILS_SetMaxClip1(ply:Give("gweapon_ar2"))
				ply:GiveAmmo(90,"ar2")
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_ar2')
			end
			if(math.random(1,4)==1)then
				ply:Give("gweapon_axe")
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_axe')
			end
			--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_fists')
			
			--end
			--ply:Give("wep_swrd_sword")
			--ply:Give("wep_swrd_halberd")
		end
		_BSF_DontCreateRag = nil
	end
end

function GM:PlayerSetModel( ply )
	--models/player/police.mdl
	if(math.random(1,4)==1)then
		ply:SetModel("models/player/barney.mdl")
	elseif(math.random(1,4)==1)then
		ply:SetModel("models/player/kleiner.mdl")
	else
		ply:SetModel("models/player/Group01/male_01.mdl")
	end
end