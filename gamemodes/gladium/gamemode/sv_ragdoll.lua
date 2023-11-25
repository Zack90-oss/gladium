include("sv_ragdoll_control.lua")

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:CreateRagdoll()
	
end


function GM:SetupRagdoll(ply)
	local model = ply:GetModel()
	local pos = ply:GetPos()
	local angs = ply:GetAngles()
	
	local rag = ents.Create("prop_ragdoll")
	rag:SetModel(model)
	rag:SetAngles(angs)
	rag:SetPos(pos+vector_up*10)
	rag:Spawn()
	rag:Activate()
	
	rag:SetOwner(ply)
	
	--print(rag)
	BSF_RAGDOLLCONTROL_WEAPONS:StripWeapons(rag)
	BSF_RAGDOLLCONTROL:KillPlayerRagdoll(ply,true)
	BSF_RAGDOLLCONTROL:SetupRagdoll(rag,ply)
	return rag
end

hook.Add("PlayerDeath","BSF",function(ply)
	--BSF_RAGDOLLCONTROL:KillPlayerRagdoll(ply)
end)