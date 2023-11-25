BSF_Maps = BSF_Maps or {}

function BSF_Maps:ReloadMap(map)
	map = map or game.GetMap() 
	local rootFolder = "gladium/maps/"
	
	print("BSF: Reloading Maps")
	print(rootFolder)

	--local _, dirs = file.Find( rootFolder..map, "LUA" )
	--for _,dir in pairs(dirs)do
	local files, _ = file.Find( rootFolder..map..'/*', "LUA" )
	if(files)then
		BSF_MAPINFO = {}
		for _,filename in pairs(files)do
			AddCSLuaFile(rootFolder..map..'/'..filename)
			include(rootFolder..map..'/'..filename)
		end
	end
	--end
end
BSF_Maps:ReloadMap()