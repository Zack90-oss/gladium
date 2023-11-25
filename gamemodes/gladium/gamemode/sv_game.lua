BSF_GAME = BSF_GAME or {}


BSF_GAME.ActiveGamemode = BSF_GAME.ActiveGamemode
function BSF_GAME:Start(mode)
	BSF_GAME.ActiveGamemode = mode
	
	local storedmode = BSF_GAMEMODES[mode]
	if(storedmode)then
		if(storedmode.Initialize)then
			if(storedmode:Initialize() == false)then
				BSF_GAME.ActiveGamemode = "_"
			end
		end
	end
end

function BSF_GAME:CanSpawn(ply)
	return true
end

hook.Add("PlayerDeath","BSF_GAME",function(...)
	BSF_GAME.ActiveGamemode = BSF_GAME.ActiveGamemode or "_"
	if(BSF_GAMEMODES[BSF_GAME.ActiveGamemode] and BSF_GAMEMODES[BSF_GAME.ActiveGamemode].Hook_PlayerDeath)then
		BSF_GAMEMODES[BSF_GAME.ActiveGamemode]:Hook_PlayerDeath(...)
	end
end)

hook.Add("PlayerDeathThink","BSF_GAME",function(...)
	BSF_GAME.ActiveGamemode = BSF_GAME.ActiveGamemode or "_"
	if(BSF_GAMEMODES[BSF_GAME.ActiveGamemode] and BSF_GAMEMODES[BSF_GAME.ActiveGamemode].Hook_PlayerDeathThink)then
		return BSF_GAMEMODES[BSF_GAME.ActiveGamemode]:Hook_PlayerDeathThink(...)
	end
end)

hook.Add("PlayerDisconnected","BSF_GAME",function(...)
	BSF_GAME.ActiveGamemode = BSF_GAME.ActiveGamemode or "_"
	if(BSF_GAMEMODES[BSF_GAME.ActiveGamemode] and BSF_GAMEMODES[BSF_GAME.ActiveGamemode].Hook_PlayerDisconnected)then
		BSF_GAMEMODES[BSF_GAME.ActiveGamemode]:Hook_PlayerDisconnected(...)
	end
end)