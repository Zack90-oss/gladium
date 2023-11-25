BSF_GAMEMODES = BSF_GAMEMODES or {}


//Plantation
BSF_GAMEMODES["Deathmatch"] = {}
local m_Plantation = BSF_GAMEMODES["Deathmatch"]
function m_Plantation:Initialize()
	if(!BSF_MAPINFO)then return false end	--If no info about this map then bail
	
	game.CleanUpMap()
	
	BSF_GAME.State = BSFENUMS_GAME_IN
	local teams = {
		["t"] = 50,
		["ct"] = 50,
	}
	local teamplayers = BSF_GAME:SortPlayersByTeams(teams)
	BSF_GAME:SetTeams(teamplayers)
	
	local spawnes = BSF_MAPINFO["spawns_Deathmatch"]

	for tname,players in pairs(teamplayers)do
		for _,ply in pairs(players)do
			if(tname=="ct")then
				ply:SetModel("models/player/riot.mdl")
			else
				ply:SetModel("models/player/leet.mdl")
			end
			_BSF_DontCreateRag = true	--Set this to avoid ragdoll creation on spawn, do it your way instead
			_BSF_DontSetPlayerModel = true
			--ply:Kill()
			ply:Spawn()
			ply:StripWeapons()
			ply:StripAmmo()
			
			local rag = GAMEMODE:SetupRagdoll(ply)
			BSF_RAGDOLLCONTROL:SpectateRagdoll(ply,rag)
			
			ply:ChatPrint("You are "..tname)
			ply:SetBSFPos(table.Random(spawnes[tname])["Pos"])
			if(tname=="ct")then
				--BSF_UTILS_SetMaxClip1(ply:Give("gweapon_ar2"))
				BSF_UTILS_SetMaxClip1(ply:Give("gweapon_m4a1"))
				ply:GiveAmmo(90,"ar2")
				BSF_UTILS_SetMaxClip1(ply:Give("gweapon_pistol"))
				ply:GiveAmmo(12,"pistol")
				ply:Give("gweapon_stunstick")
				ply:Give("gweapon_fists")
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_stunstick')
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_fists')
			else
				BSF_UTILS_SetMaxClip1(ply:Give("gweapon_ak"))
				ply:GiveAmmo(90,"ar2")
				BSF_UTILS_SetMaxClip1(ply:Give("gweapon_pistol"))
				ply:GiveAmmo(12,"pistol")
				ply:Give("gweapon_knife")
				ply:Give("gweapon_fists")
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_knife')
				--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,'gweapon_fists')
			end
		end
	end
	
end

function m_Plantation:CheckRoundState()
	if(BSF_GAME:GetState()==BSFENUMS_GAME_END)then return end
	local teams = table.Copy(BSF_GAME.ActiveTeamsCompare)
	for _,ply in pairs(player.GetAll())do
		if(ply.BSF_Team)then
			if(ply:Alive())then
				teams[ply.BSF_Team] = (teams[ply.BSF_Team] or 0) + 1
			else
				teams[ply.BSF_Team] = teams[ply.BSF_Team] or 0
			end
		end
	end
	
	for tname,count in pairs(teams)do
		--print(tname,count)
		if(count<1)then
			PrintMessage(HUD_PRINTTALK, tname.." Lost.")
			BSF_GAME.State = BSFENUMS_GAME_END
			BSF_GAME:Start("Deathmatch")
		end
	end
end

m_Plantation.Hook_PlayerDisconnected = function(self,ply)
	self:CheckRoundState()
end

m_Plantation.Hook_PlayerDeath = function(self,ply,infl,attacker)
	self:CheckRoundState()
end

m_Plantation.Hook_PlayerDeathThink = function(ply)
	if(BSF_GAME:GetState()==BSFENUMS_GAME_IN)then
		return false
	end
	return nil
end