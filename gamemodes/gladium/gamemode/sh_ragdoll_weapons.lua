--DEPRECATED; USE DEFAULT SWEP REGISTRATION

BSF_RAGDOLLCONTROL_WEAPONS = BSF_RAGDOLLCONTROL_WEAPONS or {}
BSF_RAGDOLLCONTROL_WEAPONS.Weapons = BSF_RAGDOLLCONTROL_WEAPONS.Weapons or {}

function BSF_RAGDOLLCONTROL_WEAPONS:ReloadAllWeaponScripts(newwep)
	--newwep = BSF_RAGDOLLCONTROL_WEAPONS.Weapons[newwep]
	for _,rag in pairs(ents.FindByClass("prop_ragdoll"))do
		if(rag.BSF_Weapons)then
			for class,wep in pairs(rag.BSF_Weapons)do
				if(newwep == class)then
					newwep = BSF_RAGDOLLCONTROL_WEAPONS.Weapons[newwep]
					local active = false
					if(BSF_RAGDOLLCONTROL_WEAPONS:GetActiveWeapon(rag)==wep)then
						active = true
					end
					--BSF_RAGDOLLCONTROL_WEAPONS:StripWeapon(rag,class)
					--BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,class)
					for var,val in pairs(newwep)do
						rag.BSF_Weapons[class][var] = val
					end
					if(active)then
						BSF_RAGDOLLCONTROL_WEAPONS:SetActiveWeapon(rag,class)
					end
				end
			end
		end
	end
end

BSF_NET_IDTOTYPE = {
	[0] = "Int",
	[1] = "UInt",
}

function BSF_RAGDOLLCONTROL_WEAPONS:AddEssentials(SWEP,filename)	--Yes, I realize i can use default SWEP and ENT objects.
	SWEP.Class = string.StripExtension(filename)
	SWEP._Valid = true
	SWEP.IsValid = function(self)
		if(!IsValid(self.Owner)) or (self.Owner.Alive and !self.Owner:Alive())then
			return false
		end
		return self._Valid
	end
	
	--[[
	SWEP._NWVARS = {	--Range of var id's [1..31]  --Sending id in 5 bits
		["Int"] = {},
		["UInt"] = {},
		["String"] = {},
	}
	SWEP._NWVARSNamesToID = {
		["Int"] = {},
		["UInt"] = {},
		["String"] = {},
	}
	function SWEP:NetworkVar(typ,name,bits,id)	--You don't need to pick id here. Everything now have to be in order but you can rewrite some vars
		if(self._NWVARS[typ])then
			id = id or #self._NWVARS[typ] + 1
			self._NWVARSNamesToID[name] = id
			
			
		end
	end
	]]
end

function BSF_RAGDOLLCONTROL_WEAPONS:ReloadWeapons()	--I started this whole system just to wield several weapons at same time(Check if this is complete)
	local rootFolder = "gladium/weapons/"
	
	print("BSF: Reloading Weapons")
	print(rootFolder)

	local files, _ = file.Find( rootFolder..'*', "LUA" )
	for _,filename in pairs(files)do
		AddCSLuaFile(rootFolder..filename)
		
		BSF_RAGDOLLCONTROL_WEAPONS.Weapons[string.StripExtension(filename)] = BSF_RAGDOLLCONTROL_WEAPONS.Weapons[string.StripExtension(filename)] or {}
		SWEP = BSF_RAGDOLLCONTROL_WEAPONS.Weapons[string.StripExtension(filename)]
		
		include(rootFolder..filename)
		
		BSF_RAGDOLLCONTROL_WEAPONS:AddEssentials(SWEP,filename)
		
		BSF_RAGDOLLCONTROL_WEAPONS:ReloadAllWeaponScripts(string.StripExtension(filename))
		SWEP = nil
	end
end
BSF_RAGDOLLCONTROL_WEAPONS:ReloadWeapons()

function BSF_RAGDOLLCONTROL_WEAPONS:_GetWeaponCopy(wepclass)
	return table.Copy(BSF_RAGDOLLCONTROL_WEAPONS.Weapons[wepclass])
end

function BSF_RAGDOLLCONTROL_WEAPONS:_InitializeWeapon(rag,wep)
	wep.Owner = rag:GetOwner()
	--print(rag:GetOwner())
	if(!wep._Initialized)then
		wep._Initialized = true
		if(wep.SetupDataTables)then
			wep:SetupDataTables()
		end
		
		wep:Initialize()
		BSF_RAGDOLLCONTROL_WEAPONS:_AddWeaponThinkHook(wep)
		BSF_RAGDOLLCONTROL_WEAPONS:_AddWeaponAutoHooks(wep)
	end
end

BSF_RAGDOLLCONTROL_WEAPONS._WeaponThinkHookCall = function(wep)
	if(wep.BSF_ThinkAlways or BSF_RAGDOLLCONTROL_WEAPONS:GetActiveWeapon(wep.Owner)==wep)then
		wep:Think()
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:_AddWeaponThinkHook(wep)
	hook.Add("Think",wep,BSF_RAGDOLLCONTROL_WEAPONS._WeaponThinkHookCall)
end

function BSF_RAGDOLLCONTROL_WEAPONS:_AddWeaponAutoHooks(wep)
	if(wep.AutoHooks)then
		for _,hok in pairs(wep.AutoHooks)do
			local strippedhok = string.gsub(hok,"[(){}/.%[%] ]","")
			hook.Add(hok,wep,wep["AutoHook_"..strippedhok])
		end
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:_RemoveWeaponThinkHook(wep)
	wep._Valid = false
	hook.Remove("Think",wep)
end

//NET SV

function BSF_RAGDOLLCONTROL_WEAPONS:NET_GiveWeapon(rag,wepclass)
	local ply = rag:GetOwner()
	if(SERVER and !BSF_RAGDOLLCONTROL:IsRagdollJustCreated(rag))then	--If it's just created then there's no point in sending this info to client. Client will request full update later
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(GiveWeapon)")
			net.WriteString(wepclass)
		net.Send(ply)
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:NET_StripWeapon(rag,wepclass)
	local ply = rag:GetOwner()
	if(SERVER and !BSF_RAGDOLLCONTROL:IsRagdollJustCreated(rag))then
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(StripWeapon)")
			net.WriteString(wepclass)
		net.Send(ply)
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:NET_StripWeapons(rag)
	local ply = rag:GetOwner()
	if(SERVER and !BSF_RAGDOLLCONTROL:IsRagdollJustCreated(rag))then
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(StripWeapons)")
		net.Send(ply)
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:NET_SelectWeapon(rag,wepclass)
	local ply = rag:GetOwner()
	if(SERVER and !BSF_RAGDOLLCONTROL:IsRagdollJustCreated(rag))then
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(SelectWeapon)")
			net.WriteString(wepclass)
		net.Send(ply)
	end
end

//Local Recoil Network
if(CLIENT)then
	function BSF_RAGDOLLCONTROL_WEAPONS:Recoil(eyerecoil)
		LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+eyerecoil)
	end
	net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(Recoil)",function()
		BSF_RAGDOLLCONTROL_WEAPONS:Recoil(net.ReadAngle())
	end)
else
	util.AddNetworkString("BSF_RAGDOLLCONTROL_WEAPONS(Recoil)")
	function BSF_RAGDOLLCONTROL_WEAPONS:Recoil(ply,eyerecoil)
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(Recoil)")
			net.WriteAngle(eyerecoil)
		net.Send(ply)
	end
end
//Give - Strip

function BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(rag,wepclass)
	if(rag.IsPlayer and rag:IsPlayer())then
		rag = rag.BSF_Ragdoll
	end
	rag.BSF_Weapons = rag.BSF_Weapons or {}
	if(!rag.BSF_Weapons[wepclass])then
		rag.BSF_Weapons[wepclass] = BSF_RAGDOLLCONTROL_WEAPONS:_GetWeaponCopy(wepclass)
		BSF_RAGDOLLCONTROL_WEAPONS:_InitializeWeapon(rag,rag.BSF_Weapons[wepclass])
		
		BSF_RAGDOLLCONTROL_WEAPONS:GuessActiveWeapon(rag)
		
		BSF_RAGDOLLCONTROL_WEAPONS:NET_GiveWeapon(rag,wepclass) --NET
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:StripWeapon(rag,wepclass)
	if(rag.IsPlayer and rag:IsPlayer())then
		rag = rag.BSF_Ragdoll
	end
	rag.BSF_Weapons = rag.BSF_Weapons or {}
	if(rag.BSF_Weapons[wepclass])then
		BSF_RAGDOLLCONTROL_WEAPONS:_RemoveWeaponThinkHook(rag.BSF_Weapons[wepclass])
		BSF_RAGDOLLCONTROL_WEAPONS:SetActiveWeapon(rag,nil)
		rag.BSF_Weapons[wepclass]:OnRemove()
		rag.BSF_Weapons[wepclass] = nil
		
		BSF_RAGDOLLCONTROL_WEAPONS:GuessActiveWeapon(rag)
		
		BSF_RAGDOLLCONTROL_WEAPONS:NET_StripWeapon(rag,wepclass) --NET
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:StripWeapons(rag)
	if(rag.IsPlayer and rag:IsPlayer())then
		rag = rag.BSF_Ragdoll
	end
	rag.BSF_Weapons = rag.BSF_Weapons or {}
	
	for class,wep in pairs(rag.BSF_Weapons)do
		BSF_RAGDOLLCONTROL_WEAPONS:StripWeapon(rag,class)
	end
	
	BSF_RAGDOLLCONTROL_WEAPONS:NET_StripWeapons(rag)	--NET
end

function BSF_RAGDOLLCONTROL_WEAPONS:SetActiveWeapon(rag,wepclass)
	if(rag.IsPlayer and rag:IsPlayer())then
		rag = rag.BSF_Ragdoll
	end
	rag.BSF_Weapons = rag.BSF_Weapons or {}
	
	if(rag.BSF_Weapons[wepclass])then
		rag.BSF_ActiveWeapon = rag.BSF_Weapons[wepclass]
	elseif(!wepclass)then
		rag.BSF_ActiveWeapon = nil
	end
	
	BSF_RAGDOLLCONTROL_WEAPONS:NET_SelectWeapon(rag,wepclass or "_NULL")	--NET
end

function BSF_RAGDOLLCONTROL_WEAPONS:SelectWeapon(ragorply,wepclass,forced)
	if(ragorply.IsPlayer and ragorply:IsPlayer())then
		ragorply = ragorply.BSF_Ragdoll
	end
	ragorply.BSF_Weapons = ragorply.BSF_Weapons or {}
	
	--Holster - Deploy
	local disallow = false
	if(BSF_RAGDOLLCONTROL_WEAPONS:GetActiveWeapon(ragorply)!=ragorply.BSF_Weapons[wepclass])then
		if(BSF_RAGDOLLCONTROL_WEAPONS:GetActiveWeapon(ragorply))then
			disallow = BSF_RAGDOLLCONTROL_WEAPONS:GetActiveWeapon(ragorply):Holster(wepclass)
		end
		if((!disallow or forced) and ragorply.BSF_Weapons[wepclass])then
			--print(ragorply.BSF_Weapons[wepclass])
			BSF_RAGDOLLCONTROL_WEAPONS:SetActiveWeapon(ragorply,wepclass)
			ragorply.BSF_Weapons[wepclass]:Deploy()
		end
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:GuessActiveWeapon(rag)
	rag.BSF_Weapons = rag.BSF_Weapons or {}
	local firstwep
	local count = 0
	for class,wep in pairs(rag.BSF_Weapons)do
		firstwep = firstwep or class
		count = count + 1
	end
	if(count==1)then
		BSF_RAGDOLLCONTROL_WEAPONS:SelectWeapon(rag,firstwep)
	end
end


function BSF_RAGDOLLCONTROL_WEAPONS:GetActiveWeapon(ragorply)
	if(ragorply.IsPlayer and ragorply:IsPlayer())then
		ragorply = ragorply.BSF_Ragdoll
	end
	return ragorply.BSF_ActiveWeapon
end

function BSF_RAGDOLLCONTROL_WEAPONS:IsWeaponActive(ragorply,wepclass)
	if(ragorply.IsPlayer and ragorply:IsPlayer())then
		ragorply = ragorply.BSF_Ragdoll
	end
	if(ragorply.BSF_ActiveWeapon)then
		if(ragorply.BSF_ActiveWeapon.Class == wepclass)then
			return true
		end
	end
	return false
end

function BSF_RAGDOLLCONTROL_WEAPONS:IsTargetSoft(targ)
	return (targ:IsNPC() or targ:IsPlayer() or targ.BSFRAG)
end
