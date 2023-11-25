util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(GiveWeapon)")
util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(StripWeapon)")
util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(StripWeapons)")

util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(SelectWeapon)")	--There is an option to force select weapon
util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(GMODSelectWeapon)")

util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(FullUpdate)")

net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(SelectWeapon)",function( len, ply )
	if(IsValid(ply.BSF_Ragdoll))then
		local wepclass = net.ReadString()
		if(wepclass == "_NULL")then
			wepclass = nil
		end
		
		BSF_RAGDOLLCONTROL_WEAPONS:SelectWeapon(ply.BSF_Ragdoll,wepclass)
	end
end)

net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(GMODSelectWeapon)",function( len, ply )
	ply:SelectWeapon(net.ReadString())
	--ply:SetActiveWeapon(net.ReadString())
end)

net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(FullUpdate)",function( len, ply )
	local rag = ply.BSF_Ragdoll
	if(IsValid(rag))then
		for wepclass,wep in pairs(rag.BSF_Weapons)do
			BSF_RAGDOLLCONTROL_WEAPONS:NET_GiveWeapon(rag,wepclass)
			if(BSF_RAGDOLLCONTROL_WEAPONS:IsWeaponActive(rag,wepclass))then
				BSF_RAGDOLLCONTROL_WEAPONS:NET_SelectWeapon(rag,wepclass)
			end
		end
	end
end)