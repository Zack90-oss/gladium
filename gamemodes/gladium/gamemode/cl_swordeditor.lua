SWRD_Editor = SWRD_Editor or {}
SWRD_Editor.Version = 1
SWRD_Editor.FirstColors={
	Color(175,175,175),
	Color(0,175,200),
	Color(150,230,0),
}
hook.Add( "Think", "SwordsEditor_Think", function()
	if( !SWRD_Editor:IsOpened() )then
		return nil
	end
	
	local holdKey
	local binding = input.LookupBinding("+menu_context")
	holdKey = input.GetKeyCode(binding)
	
	local menu=SWRD_Editor:GetMainPanel()
	
	if(input.IsKeyDown(holdKey))then
		menu:SetKeyboardInputEnabled(true)
		menu:SetMouseInputEnabled(true)
	else
		menu:SetKeyboardInputEnabled(false)
		menu:SetMouseInputEnabled(false)	
	end
	
end)

function SWRD_Editor:Toggle()
	if( SWRD_Editor:IsOpened() )then
		SWRD_Editor:Close()
		return nil
	end
		SWRD_Editor.Traces={}
		SWRD_Editor.SelectedMode="mode_trace"
		SWRD_Editor.SelectedBone=nil
		SWRD_Editor.SelectedObj=nil
		SWRD_Editor.BonePos=Vector(0,0,0)
		SWRD_Editor.BoneAng=Angle(0,0,0)
		local selfsize={ 358, 800 }
		
		local menu = vgui.Create( "DFrame" )
		menu:SetSize( selfsize[1], selfsize[2] )
		menu:SetPos( ScrW()-selfsize[1], ScrH()-selfsize[2] )
		menu:MakePopup()
		--menu:SetKeyboardInputEnabled(false)
		--menu:SetMouseInputEnabled(false)
		--menu:SetDraggable(false)
		menu:ShowCloseButton(false)
		menu:SetTitle("")
		menu:DockPadding(4,4,4,4)
		menu.Paint = function(sel,w,h)
			draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
			draw.RoundedBox(0, 0, 0, w, 90, Color(175, 175, 175))
			draw.RoundedBox(0, 0, 410, w, 300, Color(175, 175, 175))
		end
		
		local bones = vgui.Create( "DComboBox", menu )
		bones:SetPos( 5, 10 )
		bones:SetSize( 200, 20 )
		bones:SetValue( "Select the bone" )
		for i=0,50 do
			local bone = LocalPlayer():GetBoneName(i)
			if(!bone)then continue end
			bones:AddChoice( bone )
		end
		bones.OnSelect = function( self, index, value )
			SWRD_Editor.SelectedBone=LocalPlayer():LookupBone(value)
		end

		local sliderPosX=vgui.Create( "DTextEntry", menu )
		sliderPosX:SetPos( 5, 30 )
		sliderPosX:SetSize( 100, 20 )
		sliderPosX:SetText( "Pos X " )
		sliderPosX:SetNumeric( true )
		sliderPosX:SetValue( 0 )
		sliderPosX.OnChange = function( self, value )
			SWRD_Editor.BonePos[1]=tonumber(self:GetValue()) or 0
		end

		local sliderPosY=vgui.Create( "DTextEntry", menu )
		sliderPosY:SetPos( 5, 50 )
		sliderPosY:SetSize( 100, 20 )
		sliderPosY:SetText( "Pos Y " )
		sliderPosY:SetNumeric( true )
		sliderPosY:SetValue( 0 )
		sliderPosY.OnChange = function( self )
			SWRD_Editor.BonePos[2]=tonumber(self:GetValue()) or 0
		end
		
		local sliderPosZ=vgui.Create( "DTextEntry", menu )
		sliderPosZ:SetPos( 5, 70 )
		sliderPosZ:SetSize( 100, 20 )
		sliderPosZ:SetText( "Pos Z " )
		sliderPosZ:SetNumeric( true )
		sliderPosZ:SetValue( 0 )
		sliderPosZ.OnChange = function( self )
			SWRD_Editor.BonePos[3]=tonumber(self:GetValue()) or 0
		end

		local sliderX=vgui.Create( "DNumSlider", menu )
		sliderX:SetPos( 105, 30 )
		sliderX:SetSize( 200, 20 )
		sliderX:SetText( " Pos X / Ang X " )
		sliderX:SetMin( 0 )
		sliderX:SetMax( 360 )
		sliderX:SetDecimals( 0 )
		sliderX:SetValue( 0 )
		sliderX:SetDark(true)
		sliderX.OnValueChanged = function( self, value )
			SWRD_Editor.BoneAng[1]=value
		end

		local sliderY=vgui.Create( "DNumSlider", menu )
		sliderY:SetPos( 105, 50 )
		sliderY:SetSize( 200, 20 )
		sliderY:SetText( " Pos Y / Ang Y " )
		sliderY:SetMin( 0 )
		sliderY:SetMax( 360 )
		sliderY:SetDecimals( 0 )
		sliderY:SetValue( 0 )
		sliderY:SetDark(true)
		sliderY.OnValueChanged = function( self, value )
			SWRD_Editor.BoneAng[2]=value
		end
		
		local sliderZ=vgui.Create( "DNumSlider", menu )
		sliderZ:SetPos( 105, 70 )
		sliderZ:SetSize( 200, 20 )
		sliderZ:SetText( " Pos Z / Ang Z " )
		sliderZ:SetMin( 0 )
		sliderZ:SetMax( 360 )
		sliderZ:SetDecimals( 0 )
		sliderZ:SetValue( 0 )
		sliderZ:SetDark(true)
		sliderZ.OnValueChanged = function( self, value )
			SWRD_Editor.BoneAng[3]=value
		end

		local options = vgui.Create( "DComboBox", menu )
		options:SetPos( 5, 100 )
		options:SetSize( 95, 20 )
		options:SetValue( Translate(SWRD_Editor.SelectedMode) )
		options:AddChoice( Translate("mode_trace") )
		options:AddChoice( Translate("mode_tarray") )
		options.OnSelect = function( self, index, value )
			SWRD_Editor.SelectedMode=Translate(value)		--Translate back
		end

		local scroll = vgui.Create( "DScrollPanel", menu )
		--scroll:SetImage( "icon16/delete.png" )
		scroll:SetPos( 0, 130 )
		scroll:SetSize(selfsize[1],280)
		local sbar = scroll:GetVBar()
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(200, 100, 0))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(200, 100, 0))
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120))
		end


		local but_add = vgui.Create( "DImageButton", menu )
		but_add:SetImage( "icon16/add.png" )
		but_add:SetPos( 250, 90 )
		--but_add:SizeToContents()
		but_add:SetSize(32,32)
		but_add.DoClick = function()
			--surface.PlaySound( "buttons/lightswitch2.wav" )
			local newobj = scroll:Add( "DButton" )
			newobj.Class = SWRD_Editor.SelectedMode
			newobj.ID = #SWRD_Editor.Traces+1
			if(newobj.Class=="mode_trace")then
				newobj.Info={
					Pos=Vector(0,0,0),
					Ang=Angle(0,0,0),
					IgnoreZ=true,
					Length=50,
				}
			end
			if(newobj.Class=="mode_tarray")then
				newobj.Info={
					Pos=Vector(0,0,0),
					Ang=Angle(0,90,0),
					IgnoreZ=true,
					Length=30,
					TLength=20,
					TAng=Angle(0,0,0),
					TCount=5,
				}
			end
			newobj.Color=SWRD_Editor.FirstColors[newobj.ID] or Color(math.random(100,255),math.random(100,255),math.random(100,255))
			newobj:SetText(Translate(SWRD_Editor.SelectedMode).." #"..newobj.ID)
			newobj:SetSize(100,50)
			newobj:Dock(TOP)
			newobj.DoClick = function(sel)
				SWRD_Editor.SelectedObj=sel
				local optionpanel=SWRD_Editor.OptionPanel
				local info = sel.Info
				
				optionpanel.TsliderPosX:SetValue(info.Pos[1])
				optionpanel.TsliderPosY:SetValue(info.Pos[2])
				optionpanel.TsliderPosZ:SetValue(info.Pos[3])
				optionpanel.TsliderX:SetValue(info.Ang[1])
				optionpanel.TsliderY:SetValue(info.Ang[2])
				optionpanel.TsliderZ:SetValue(info.Ang[3])
				
				optionpanel.ignoreZ:SetValue(info.IgnoreZ)
				optionpanel.length:SetValue(info.Length)
				optionpanel.Mixer:SetColor(sel.Color)
				
				if(sel.Class=="mode_tarray")then
					optionpanel.AsliderX:SetValue(info.TAng[1])
					optionpanel.AsliderY:SetValue(info.TAng[2])
					optionpanel.AsliderZ:SetValue(info.TAng[3])
					optionpanel.Tlength:SetValue(info.TLength)
					optionpanel.Tcount:SetValue(info.TCount)
				end
			end
			newobj.Paint = function(sel,w,h)
				draw.RoundedBox(8, 0, 0, w, h, sel.Color)
				if(SWRD_Editor.SelectedObj==sel)then
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawOutlinedRect(0,0,w,h,5)
				end
			end
			table.insert(SWRD_Editor.Traces,newobj)
		end

		local but_del = vgui.Create( "DImageButton", menu )
		but_del:SetImage( "icon16/delete.png" )
		but_del:SetPos( 290, 90 )
		but_del:SetSize(32,32)
		but_del.DoClick = function()
			if(!IsValid(SWRD_Editor.SelectedObj))then return end
			--surface.PlaySound( "buttons/lightswitch2.wav" )
			SWRD_Editor.Traces[SWRD_Editor.SelectedObj.ID]=nil
			SWRD_Editor.SelectedObj:Remove()
		end


		--[[Trace options]]--
		SWRD_Editor.OptionPanel={}
		local optionpanel=SWRD_Editor.OptionPanel
		optionpanel.TsliderPosX=vgui.Create( "DTextEntry", menu )
		optionpanel.TsliderPosX:SetPos( 5, 420 )
		optionpanel.TsliderPosX:SetSize( 100, 20 )
		optionpanel.TsliderPosX:SetText( "Pos X " )
		optionpanel.TsliderPosX:SetNumeric( true )
		optionpanel.TsliderPosX:SetValue( 0 )
		optionpanel.TsliderPosX.OnChange = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.Pos[1]=tonumber(self:GetValue()) or 0
		end

		optionpanel.TsliderPosY=vgui.Create( "DTextEntry", menu )
		optionpanel.TsliderPosY:SetPos( 5, 440 )
		optionpanel.TsliderPosY:SetSize( 100, 20 )
		optionpanel.TsliderPosY:SetText( "Pos Y " )
		optionpanel.TsliderPosY:SetNumeric( true )
		optionpanel.TsliderPosY:SetValue( 0 )
		optionpanel.TsliderPosY.OnChange = function( self )
			local info = SWRD_Editor.SelectedObj.Info
			info.Pos[2]=tonumber(self:GetValue()) or 0
		end
		
		optionpanel.TsliderPosZ=vgui.Create( "DTextEntry", menu )
		optionpanel.TsliderPosZ:SetPos( 5, 460 )
		optionpanel.TsliderPosZ:SetSize( 100, 20 )
		optionpanel.TsliderPosZ:SetText( "Pos Z " )
		optionpanel.TsliderPosZ:SetNumeric( true )
		optionpanel.TsliderPosZ:SetValue( 0 )
		optionpanel.TsliderPosZ.OnChange = function( self )
			local info = SWRD_Editor.SelectedObj.Info
			info.Pos[3]=tonumber(self:GetValue()) or 0
		end

		optionpanel.TsliderX=vgui.Create( "DNumSlider", menu )
		optionpanel.TsliderX:SetPos( 105, 420 )
		optionpanel.TsliderX:SetSize( 200, 20 )
		optionpanel.TsliderX:SetText( " Pos X / Ang X " )
		optionpanel.TsliderX:SetMin( 0 )
		optionpanel.TsliderX:SetMax( 360 )
		optionpanel.TsliderX:SetDecimals( 0 )
		optionpanel.TsliderX:SetValue( 0 )
		optionpanel.TsliderX:SetDark(true)
		optionpanel.TsliderX.OnValueChanged = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.Ang[1]=math.Round(value)
		end

		optionpanel.TsliderY=vgui.Create( "DNumSlider", menu )
		optionpanel.TsliderY:SetPos( 105, 440 )
		optionpanel.TsliderY:SetSize( 200, 20 )
		optionpanel.TsliderY:SetText( " Pos Y / Ang Y " )
		optionpanel.TsliderY:SetMin( 0 )
		optionpanel.TsliderY:SetMax( 360 )
		optionpanel.TsliderY:SetDecimals( 0 )
		optionpanel.TsliderY:SetValue( 0 )
		optionpanel.TsliderY:SetDark(true)
		optionpanel.TsliderY.OnValueChanged = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.Ang[2]=math.Round(value)
		end
		
		optionpanel.TsliderZ=vgui.Create( "DNumSlider", menu )
		optionpanel.TsliderZ:SetPos( 105, 460 )
		optionpanel.TsliderZ:SetSize( 200, 20 )
		optionpanel.TsliderZ:SetText( " Pos Z / Ang Z " )
		optionpanel.TsliderZ:SetMin( 0 )
		optionpanel.TsliderZ:SetMax( 360 )
		optionpanel.TsliderZ:SetDecimals( 0 )
		optionpanel.TsliderZ:SetValue( 0 )
		optionpanel.TsliderZ:SetDark(true)
		optionpanel.TsliderZ.OnValueChanged = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.Ang[3]=math.Round(value)
		end

		optionpanel.ignoreZ=vgui.Create( "DCheckBoxLabel", menu )
		optionpanel.ignoreZ:SetPos( 5, 485 )
		optionpanel.ignoreZ:SetText("Render Z")	--yes
		optionpanel.ignoreZ:SetValue( true )
		optionpanel.ignoreZ:SizeToContents()
		optionpanel.ignoreZ.OnChange = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.IgnoreZ=value
		end

		optionpanel.length=vgui.Create( "DTextEntry", menu )
		optionpanel.length:SetPos( 145, 482 )
		optionpanel.length:SetSize( 50, 20 )
		optionpanel.length:SetPlaceholderText( "Length" )
		optionpanel.length:SetNumeric( true )
		optionpanel.length.OnChange = function( self )
			local info = SWRD_Editor.SelectedObj.Info
			info.Length=tonumber(self:GetValue()) or 0
		end

		--[[TArray]]--
		optionpanel.AsliderX=vgui.Create( "DNumSlider", menu )
		optionpanel.AsliderX:SetPos( 5, 505 )
		optionpanel.AsliderX:SetSize( 200, 20 )
		optionpanel.AsliderX:SetText( "TArray Ang X " )
		optionpanel.AsliderX:SetMin( 0 )
		optionpanel.AsliderX:SetMax( 360 )
		optionpanel.AsliderX:SetDecimals( 0 )
		optionpanel.AsliderX:SetValue( 0 )
		optionpanel.AsliderX:SetDark(true)
		optionpanel.AsliderX.OnValueChanged = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.TAng[1]=math.Round(value)
		end
		optionpanel.AsliderX.Paint = function(sel,w,h)
			if(!SWRD_Editor.SelectedObj or SWRD_Editor.SelectedObj.Class!="mode_tarray")then
				draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
			end
		end
		
		optionpanel.AsliderY=vgui.Create( "DNumSlider", menu )
		optionpanel.AsliderY:SetPos( 5, 525 )
		optionpanel.AsliderY:SetSize( 200, 20 )
		optionpanel.AsliderY:SetText( "TArray Ang Y " )
		optionpanel.AsliderY:SetMin( 0 )
		optionpanel.AsliderY:SetMax( 360 )
		optionpanel.AsliderY:SetDecimals( 0 )
		optionpanel.AsliderY:SetValue( 0 )
		optionpanel.AsliderY:SetDark(true)
		optionpanel.AsliderY.OnValueChanged = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.TAng[2]=math.Round(value)
		end
		optionpanel.AsliderY.Paint = function(sel,w,h)
			if(!SWRD_Editor.SelectedObj or SWRD_Editor.SelectedObj.Class!="mode_tarray")then
				draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
			end
		end
		
		optionpanel.AsliderZ=vgui.Create( "DNumSlider", menu )
		optionpanel.AsliderZ:SetPos( 5, 545 )
		optionpanel.AsliderZ:SetSize( 200, 20 )
		optionpanel.AsliderZ:SetText( "TArray Ang Z " )
		optionpanel.AsliderZ:SetMin( 0 )
		optionpanel.AsliderZ:SetMax( 360 )
		optionpanel.AsliderZ:SetDecimals( 0 )
		optionpanel.AsliderZ:SetValue( 0 )
		optionpanel.AsliderZ:SetDark(true)
		optionpanel.AsliderZ.OnValueChanged = function( self, value )
			local info = SWRD_Editor.SelectedObj.Info
			info.TAng[3]=math.Round(value)
		end
		optionpanel.AsliderZ.Paint = function(sel,w,h)
			if(!SWRD_Editor.SelectedObj or SWRD_Editor.SelectedObj.Class!="mode_tarray")then
				draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100))
			end
		end

		optionpanel.Tlength=vgui.Create( "DTextEntry", menu )
		optionpanel.Tlength:SetPos( 205, 505 )
		optionpanel.Tlength:SetSize( 80, 20 )
		optionpanel.Tlength:SetPlaceholderText( "Stack Length" )
		optionpanel.Tlength:SetNumeric( true )
		optionpanel.Tlength.OnChange = function( self )
			local info = SWRD_Editor.SelectedObj.Info
			info.TLength=tonumber(self:GetValue()) or 0
		end
		optionpanel.Tlengthlabel = vgui.Create( "DLabel", menu )
		optionpanel.Tlengthlabel:SetPos( 285, 505 )
		optionpanel.Tlengthlabel:SetDark(true)
		optionpanel.Tlengthlabel:SetText( "Stack Length" )


		optionpanel.Tcount=vgui.Create( "DTextEntry", menu )
		optionpanel.Tcount:SetPos( 205, 525 )
		optionpanel.Tcount:SetSize( 80, 20 )
		optionpanel.Tcount:SetPlaceholderText( "Trace Count" )
		optionpanel.Tcount:SetNumeric( true )
		optionpanel.Tcount.OnChange = function( self )
			local info = SWRD_Editor.SelectedObj.Info
			info.TCount=tonumber(self:GetValue()) or 0
		end
		
		optionpanel.Tcountlabel = vgui.Create( "DLabel", menu )
		optionpanel.Tcountlabel:SetPos( 285, 525 )
		optionpanel.Tcountlabel:SetDark(true)
		optionpanel.Tcountlabel:SetText( "Trace Count" )

		optionpanel.Mixer = vgui.Create("DColorMixer", menu)
		optionpanel.Mixer:SetPos( 5, 565 )
		optionpanel.Mixer:SetSize( 200, 140 )
		optionpanel.Mixer:SetPalette(false)
		optionpanel.Mixer:SetAlphaBar(false)
		optionpanel.Mixer:SetWangs(true)
		optionpanel.Mixer:SetColor(Color(30,100,160))
		optionpanel.Mixer.ValueChanged = function( self, color )
			SWRD_Editor.SelectedObj.Color = color-- setmetatable(color,FindMetaTable('Color'))
		end
		
		local but_print = vgui.Create( "DButton", menu )
		but_print:SetPos( 0, 710 )
		but_print:SetSize(selfsize[1],90)
		but_print:SetText("Clipboard")
		but_print.DoClick = function()
			if(#SWRD_Editor.Traces==0)then
				LocalPlayer():ChatPrint("You haven't done anything yet. See tutorial on workshop page")
				return
			end
			if(!SWRD_Editor.SelectedBone)then
				LocalPlayer():ChatPrint("Select the main bone first")
				return
			end
			SWRD_Editor:CreateTraceCode()
			notification.AddLegacy( "The code is in your clipboard and console", NOTIFY_GENERIC, 2 )
			LocalPlayer():ChatPrint("The code is in your clipboard and console")
			surface.PlaySound( "buttons/lightswitch2.wav" )
		end

		function SWRD_Editor:GetMainPanel()
			return menu
		end
end


function SWRD_Editor:IsOpened()
	return SWRD_Editor.GetMainPanel~=nil and IsValid(SWRD_Editor:GetMainPanel())
end

concommand.Add("SwordsHitBoxEditor", SWRD_Editor.Toggle, nil, "Opens the weapon hit'box' editor to help you with code for SWEP:SwordTrace(). See tutorial on workshop page" )
--CreateClientConVar( "SwordsBoneToEdit", 0, true, false, "Sets the current bone to edit in bone editor, someday i will make it much easier than it is now",0)

cvars.AddChangeCallback( "SwordsBoneToEdit", function(newValue)
	SWRD_Editor:Toggle()
	SWRD_Editor:Toggle()
end)

function SWRD_Editor:Close()
	SWRD_Editor:GetMainPanel():Remove()
end

function SWRD_Editor:CreateTraceCode()
	local code="--[[Block created by SwordsHitBoxEditor version "..SWRD_Editor.Version.." starts--]]\n"
	--code=code.."local pos,ang=self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("..'"'..LocalPlayer():GetBoneName(self.SelectedBone)..'"'.."))\n"
	code=code.."local pos,ang=self:GetOwner():GetBonePosition(self:GetOwner():LookupBone(self.AttackBone))\n"
	code=code.."pos=pos+ang:Forward()*"..SWRD_Editor.BonePos[1].."+ang:Up()*"..SWRD_Editor.BonePos[2].."+ang:Right()*"..SWRD_Editor.BonePos[3].."\n"
	for i,obj in pairs(self.Traces)do
		local info = obj.Info
		if(obj.Class=="mode_trace")then
			code=code..[[
			
local trp = pos
local tra = Angle(ang)
]]
			code=code..((info.Ang[1]~=0 and [[tra:RotateAroundAxis(tra:Forward(),]]..info.Ang[1]..[[)]].."\n") or (info.Ang[1]==0 and ""))
			code=code..((info.Ang[3]~=0 and [[tra:RotateAroundAxis(tra:Up(),]]..info.Ang[3]..[[)]].."\n") or (info.Ang[3]==0 and ""))
			code=code..((info.Ang[2]~=0 and [[tra:RotateAroundAxis(tra:Right(),]]..info.Ang[2]..[[)]].."\n") or (info.Ang[2]==0 and ""))
			code=code..[[trp=trp+ang:Forward()*]]..info.Pos[1]..[[+ang:Up()*]]..info.Pos[2]..[[+ang:Right()*]]..info.Pos[3].."\n"
		
			code=code..[[
local trace = util.TraceLine( {
	start = trp,
	endpos = trp+tra:Up()*]]..info.Length..[[,
	filter = table.Add({self:GetOwner()},self.HitEnts or {}),
	mask = MASK_SHOT
} )
if(trace.Hit)then return trace end
]].."\n"
		end
		if(obj.Class=="mode_tarray")then
			code=code..[[
			
local trp = pos
local tra = Angle(ang)
]]
			code=code..((info.Ang[1]~=0 and [[tra:RotateAroundAxis(tra:Forward(),]]..info.Ang[1]..[[)]].."\n") or (info.Ang[1]==0 and ""))
			code=code..((info.Ang[3]~=0 and [[tra:RotateAroundAxis(tra:Up(),]]..info.Ang[3]..[[)]].."\n") or (info.Ang[3]==0 and ""))
			code=code..((info.Ang[2]~=0 and [[tra:RotateAroundAxis(tra:Right(),]]..info.Ang[2]..[[)]].."\n") or (info.Ang[2]==0 and ""))
			code=code..[[trp=trp+ang:Forward()*]]..info.Pos[1]..[[+ang:Up()*]]..info.Pos[2]..[[+ang:Right()*]]..info.Pos[3].."\n"

			code=code.."local atra = Angle(ang)\n"
			
			code=code..((info.TAng[1]~=0 and [[atra:RotateAroundAxis(atra:Forward(),]]..info.TAng[1]..[[)]].."\n") or (info.TAng[1]==0 and ""))
			code=code..((info.TAng[3]~=0 and [[atra:RotateAroundAxis(atra:Up(),]]..info.TAng[3]..[[)]].."\n") or (info.TAng[3]==0 and ""))
			code=code..((info.TAng[2]~=0 and [[atra:RotateAroundAxis(atra:Right(),]]..info.TAng[2]..[[)]].."\n") or (info.TAng[2]==0 and ""))
				
			code=code.."local fang = Angle(atra)\n"
			
			code=code..((info.Ang[1]~=0 and [[fang:RotateAroundAxis(fang:Forward(),]]..info.Ang[1]..[[)]].."\n") or (info.Ang[1]==0 and ""))
			code=code..((info.Ang[3]~=0 and [[fang:RotateAroundAxis(fang:Up(),]]..info.Ang[3]..[[)]].."\n") or (info.Ang[3]==0 and ""))
			code=code..((info.Ang[2]~=0 and [[fang:RotateAroundAxis(fang:Right(),]]..info.Ang[2]..[[)]].."\n") or (info.Ang[2]==0 and ""))
			
			code=code.."local step = "..info.TLength/(info.TCount-1).."\n"
			
			code=code..[[
local trace
for	i=0,]]..(info.TCount-1)..[[ do
	local offset = i*step
	local pos = trp+atra:Up()*offset
		
	trace = util.TraceLine( {
		start = pos,
		endpos = pos+fang:Up()*]]..info.Length..[[,
		filter = table.Add({self:GetOwner()},self.HitEnts or {}),
		mask = MASK_SHOT
	} )	
	if(trace.Hit)then return trace end
end]].."\n"
		end
	end
	code=code.."--[[Block created by SwordsHitBoxEditor ends--]]\n"
	MsgC( Color( 100, 220, 100, 200 ), code)
	SetClipboardText(code)
end

local function SWORDS_RenderBones()
	if(!SWRD_Editor:IsOpened() or !SWRD_Editor.SelectedBone)then return nil end
	local p,a = LocalPlayer():GetBonePosition(SWRD_Editor.SelectedBone)
	a:RotateAroundAxis(a:Forward(),SWRD_Editor.BoneAng[1])
	a:RotateAroundAxis(a:Up(),SWRD_Editor.BoneAng[3])
	a:RotateAroundAxis(a:Right(),SWRD_Editor.BoneAng[2])
	p=p+a:Forward()*SWRD_Editor.BonePos[1]+a:Up()*SWRD_Editor.BonePos[2]+a:Right()*SWRD_Editor.BonePos[3]
	
	render.DrawLine(p,p+a:Up()*5,Color(0,255,0),true)
	render.DrawLine(p,p+a:Right()*5,Color(0,0,255),true)
	render.DrawLine(p,p+a:Forward()*5,Color(255,0,0),true)
	
	local obj = SWRD_Editor.SelectedObj
	
	if(obj)then
		if(obj.Class=="mode_trace")then
			local info = obj.Info
			local trp = p
			local tra = Angle(a)
			tra:RotateAroundAxis(tra:Forward(),info.Ang[1])
			tra:RotateAroundAxis(tra:Up(),info.Ang[3])
			tra:RotateAroundAxis(tra:Right(),info.Ang[2])
			trp=trp+a:Forward()*info.Pos[1]+a:Up()*info.Pos[2]+a:Right()*info.Pos[3]
			
			render.DrawLine(trp,trp+tra:Up()*info.Length,obj.Color,info.IgnoreZ)
		end
		if(obj.Class=="mode_tarray")then
			local info = obj.Info
			local trp = p
			local tra = Angle(a)
			tra:RotateAroundAxis(tra:Forward(),info.Ang[1])
			tra:RotateAroundAxis(tra:Up(),info.Ang[3])
			tra:RotateAroundAxis(tra:Right(),info.Ang[2])
			trp=trp+a:Forward()*info.Pos[1]+a:Up()*info.Pos[2]+a:Right()*info.Pos[3]
			
			local atra = Angle(a)
			atra:RotateAroundAxis(atra:Forward(),info.TAng[1])
			atra:RotateAroundAxis(atra:Up(),info.TAng[3])
			atra:RotateAroundAxis(atra:Right(),info.TAng[2])

			local fang = Angle(atra)
			fang:RotateAroundAxis(fang:Forward(),info.Ang[1])
			fang:RotateAroundAxis(fang:Up(),info.Ang[3])
			fang:RotateAroundAxis(fang:Right(),info.Ang[2])
			
			local step = info.TLength/(info.TCount-1)
			for	i=0,info.TCount-1 do
				local offset = i*step
				local pos = trp+atra:Up()*offset
				render.DrawLine(pos,pos+fang:Up()*info.Length,obj.Color,info.IgnoreZ)
			end
		end
	end
end

hook.Add("PostDrawOpaqueRenderables", "Swords", SWORDS_RenderBones)