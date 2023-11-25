net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(GiveWeapon)",function()
	if(IsValid(BSF_RAGDOLLCONTROL:GetRagdoll()))then
		BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(BSF_RAGDOLLCONTROL:GetRagdoll(),net.ReadString())
	end
end)

net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(StripWeapon)",function()
	if(IsValid(BSF_RAGDOLLCONTROL:GetRagdoll()))then
		BSF_RAGDOLLCONTROL_WEAPONS:StripWeapon(BSF_RAGDOLLCONTROL:GetRagdoll(),net.ReadString())
	end
end)

net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(StripWeapons)",function()
	if(IsValid(BSF_RAGDOLLCONTROL:GetRagdoll()))then
		BSF_RAGDOLLCONTROL_WEAPONS:StripWeapons(BSF_RAGDOLLCONTROL:GetRagdoll())
	end
end)

net.Receive("BSF_RAGDOLLCONTROL_WEAPONS(SelectWeapon)",function()
	if(IsValid(BSF_RAGDOLLCONTROL:GetRagdoll()))then
		local wepclass = net.ReadString()
		if(wepclass == "_NULL")then
			wepclass = nil
		end
		BSF_RAGDOLLCONTROL_WEAPONS:SelectWeapon(BSF_RAGDOLLCONTROL:GetRagdoll(),wepclass,true)
	end
end)

function BSF_RAGDOLLCONTROL_WEAPONS:NETCL_SelectWeapon(wepclass)
	if(CLIENT)then
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(SelectWeapon)")
			net.WriteString(wepclass)
		net.SendToServer()
	end
end

function BSF_RAGDOLLCONTROL_WEAPONS:NETCL_GMODSelectWeapon(wepclass)
	if(CLIENT)then
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(GMODSelectWeapon)")
			net.WriteString(wepclass)
		net.SendToServer()
	end
end

function BSF_RAGDOLLCONTROL:NETCL_FullUpdate()
	if(CLIENT)then
		net.Start("BSF_RAGDOLLCONTROL_WEAPONS(FullUpdate)")
		net.SendToServer()
	end
end

local function _getKeyNum()
	for i=1,10 do
		if(input.WasKeyPressed(i))then
			return i-1
		end
	end
end

hook.Add("StartCommand","BSF_RAGDOLLCONTROL_WEAPONS",function(ply,cmd)
	local key = _getKeyNum()
	if(BSF_NextWeaponSwitch and BSF_NextWeaponSwitch<=CurTime())then
		BSF_NextWeaponSwitch = nil
	end
	if(key and !BSF_NextWeaponSwitch)then
		BSF_NextWeaponSwitch = CurTime() + 0.1
		local rag = BSF_RAGDOLLCONTROL:GetRagdoll()
		local count = 0
		
		--local weps = rag.BSF_Weapons
		--if(table.IsEmpty(weps))then
			local weps = ply:GetWeapons()
		--end
		
		--for wepclass,wep in pairs(weps)do
		for _,wep in ipairs(weps)do
			local wepclass = wep:GetClass()
			count = count + 1
			if(count == key)then
				--BSF_RAGDOLLCONTROL_WEAPONS:NETCL_SelectWeapon(wepclass)
				--BSF_RAGDOLLCONTROL_WEAPONS:NETCL_GMODSelectWeapon(wepclass)
				input.SelectWeapon(wep)
				break
			end
		end
	end
	
	--cmd:SelectWeapon()
end)

BSF_HiddenHudElems = {
	["CHudWeaponSelection"] = true,
	["CHudHealth"] = true,
	--["CHudHealth"] = true,
}
hook.Add( "HUDShouldDraw", "BSF_RAGDOLLCONTROL_WEAPONS", function( name )
	if (  BSF_HiddenHudElems[name] ) then
		return false
	end
	return true
end )

hook.Add( "HUDPaint", "BSF_RAGDOLLCONTROL_WEAPONS", function()
	local rag = BSF_RAGDOLLCONTROL:GetRagdoll()
	if(IsValid(rag))then
		local sizeW = ScreenScale(60)
		local sizeH = ScreenScale(10)
		
		local borders = 3
		--print(hp)
		
		rag.BSF_Weapons = rag.BSF_Weapons or {}
		local count = 0
		
		local weps = LocalPlayer():GetWeapons()
		
		local ystep = 70
		ystep = table.Count(weps)*50	--Loop x2
		
		--for wepclass,wep in pairs(rag.BSF_Weapons)do
		for _,wep in ipairs(weps)do
			--local wepclass = wep:GetClass()
			local wepclass = wep.PrintName
			--print(wepclass)
			
			--surface.SetDrawColor( 0, 0, 0, 128 )
			--surface.DrawRect( 35, 35, sizeW, sizeH )
			
			local x = ScrW()-50-sizeW
			local y = ScrH()-ystep+sizeH*(count+1)+borders*count
			surface.SetDrawColor( 0, 0, 0, 128 )
			surface.DrawRect( x, y, sizeW, sizeH )
			surface.SetFont( "TargetID" )
			local tw, th = surface.GetTextSize( wepclass )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( x+sizeW*0.5-tw/2, y+sizeH*0.5-th/2 ) 
			surface.DrawText( wepclass )
			surface.SetTextPos( x+10, y+sizeH*0.5-th/2 ) 
			surface.DrawText( count+1 )
			--draw.DrawText( wepclass, "TargetID", x+sizeW*0.5, y+sizeH*0.5, color_white, TEXT_ALIGN_CENTER )
			count = count + 1
		end
	end
end )