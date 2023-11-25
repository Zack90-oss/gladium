--DEPRECATED; USE BSF_RAGDOLLCONTROL_ANIMATION

GLADIUM.Animations={}

function GM:AddAnim(name,anim)
	GLADIUM.Animations[name]=anim
end

function GM:RegisterAnims()
	local rootFolder = "gladium/anims/"
	local files, directories = file.Find( rootFolder..'*', "LUA" )
	print(rootFolder)
	for i,obj in pairs(files) do
	print('Animations found!',obj)
		AddCSLuaFile(rootFolder..obj)
		include(rootFolder..obj)
	end
end

GM:AddAnim("test",function()
	local name = "test"

end)

--[[
GAMEMODE:AddAnim("test",{
	LoopFunc=function(inp)
		return 1
	end
	Anim={
		[1]={
			["ValveBiped.Bip01_Head1"]={
				secondstoarrive=1,
				pos=OffsetVector(Vector(0,0,10)),
				angle=OffsetAngle(Angle(0,0,0)),
				maxangular=200,
				maxangulardamp=200,
				maxspeed=40,
				maxspeeddamp=40,
				dampfactor=0.8,
				teleportdistance=0,
			}
		}
	}
})]]