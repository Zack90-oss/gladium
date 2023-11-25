GLADIUM={}

include( "shared.lua" )
include( "cl_player.lua" )
include( "cl_swordeditor.lua" )

include( "cl_ragdoll_control.lua" )


CreateClientConVar( "swords_language", "english", true, false, "Changes the local language for swords to be translated to")

function GM:Initialize()
	RegisterLangs()
end

function GM:PreRender()

end

function GM:RenderScreenspaceEffects()

end
--[[
function GM:CalcView( ply, pos, angles, fov )
	local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
	local bonepos = ply:GetBonePosition(bone)
	
	local expectedpos 
	local expectedangs
	
	if(SWRD_Editor:IsOpened())then
		expectedpos=pos+angles:Forward()*70
		expectedangs=(-angles:Forward()):Angle()
	else
		expectedpos=bonepos + angles:Up()*3
		expectedangs=angles
	end
	
	--expectedpos=pos
	local view = {
		origin = expectedpos,
		--origin = bonepos + angles:Up()*3,
		angles = expectedangs,
		fov = fov,
		drawviewer = true
	}

	return view	
end
]]
function GM:ClientSignOnStateChanged(id,old,new)

end