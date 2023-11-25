BSFENUMS_GAME_IN = 1
BSFENUMS_GAME_END = 0

if(SERVER)then
	//GAME
	AddCSLuaFile( "cl_game.lua" )
	include( "sv_game.lua" )
end

if(CLIENT)then
	//GAME
	include( "cl_game.lua" )
end

BSF_GAME = BSF_GAME or {}


/*
{
	["teamname"] = 10, --percent
	["teamname2"] = 30, --percent
}
*/
function BSF_GAME:SortPlayersByTeams(teams,noassign)
	local players = player.GetAll()
	local playerscount = #players
	
	local totalperc = 0
	for _,perc in pairs(teams)do
		totalperc = totalperc + perc
	end
	
	local percdisturbed = false
	local add = false
	local i = 0
	
	local constructedteams = {}
	
	for tname,perc in pairs(teams)do
		i = i + 1
		constructedteams[tname] = constructedteams[tname] or {}
		local numplayers = playerscount*(perc/totalperc)
		--[[
		local _,modnp = math.modf(numplayers)
		if(modnp!=0 and !percdisturbed)then
			percdisturbed = true
			add = true
		end
		if(add and numplayers<1)then
			add = nil
			numplayers = math.ceil(numplayers)
		else
			numplayers = math.floor(numplayers)
		end
		]]
		numplayers = math.max(math.Round(numplayers),1)
		for _=1,numplayers do
			ply,key = table.Random(players)
			if(key)then
				players[key] = nil
				constructedteams[tname][#constructedteams[tname]+1] = ply
				if(!noassign)then
					ply.BSF_Team = tname
				end
				
				print(ply,"Assigned team",tname)
			end
		end
	end
	return constructedteams
end

function BSF_GAME:SetTeams(constructedteams)	//Uses the result table from function above
	local teams = table.Copy(constructedteams)
	for tname,_ in pairs(teams)do
		teams[tname] = 0
	end
	BSF_GAME.ActiveTeamsCompare = teams
end

function BSF_GAME:GetState()
	BSF_GAME.State = BSF_GAME.State or BSFENUMS_GAME_END
	return BSF_GAME.State
end