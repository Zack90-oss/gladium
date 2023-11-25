

function RegisterLangs()
	local rootFolder = (GM or GAMEMODE).Folder:sub(11).."/gamemode/lang/"
	local files, directories = file.Find( rootFolder..'*', "LUA" )
	print(rootFolder)
	for i,obj in pairs(files) do
	print('Language found!',obj)
		AddCSLuaFile(rootFolder..obj)
		include(rootFolder..obj)
	end
end

function Translate(phrase,lang)
	lang=lang or "english"
	return _G['SWRD_LANGUAGE_'..lang][phrase]
end