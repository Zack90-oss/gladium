BSF_RAGDOLLCONTROL = BSF_RAGDOLLCONTROL or {}

include( "cl_ragdoll_weapons.lua" )

BSF_RAGDOLLCONTROL_CV_AtkDirTol = CreateClientConVar("bsf_attackdirtolerance", 5, true,true, "Attack dir(arrow on your screen) change tolerance" )
BSF_RAGDOLLCONTROL_CV_InvertAtkDir = CreateClientConVar("bsf_attackdirinvert", 0, true,true, "Invert attack direction" )

BSF_RAGDOLLCONTROL_CV_ViewThirdperson = CreateClientConVar("bsf_thirdperson", 0, true,false, "Thirdperson view" )

BSF_RAGDOLLCONTROL_CV_AutoAttacks = CreateClientConVar("bsf_autoattacks", 1, true,true, "Enable auto attack when holding attack button" )


	--Doesn't seem to work (Don't want 0 second timers)	--Seems that my ming changed
function BSF_RAGDOLLCONTROL:PreAssignRagdoll(id)
	BSF_PreRagdoll = id
end
function BSF_RAGDOLLCONTROL:AssignRagdoll(rag)
	LocalPlayer().BSF_Ragdoll = rag
	--BSF_RAGDOLLCONTROL:AddBuildBonesCallBack(BSF_RAGDOLLCONTROL:GetRagdoll())
	local bone = BSF_RAGDOLLCONTROL:GetRagdoll():LookupBone("ValveBiped.Bip01_Head1")
	BSF_RAGDOLLCONTROL:GetRagdoll():ManipulateBoneScale(bone,vector_origin)
	
	BSF_RAGDOLLCONTROL:GetRagdoll():GetOwner().BSF_Ragdoll = BSF_RAGDOLLCONTROL:GetRagdoll()
	BSF_RAGDOLLCONTROL:NETCL_FullUpdate()
	--print(rag)
end
local MAX_EDICT_BITS = 13
net.Receive("BSF_RAGDOLLCONTROL(AssignRagdoll)",function()
	--BSF_RAGDOLLCONTROL:AssignRagdoll(net.ReadEntity())
	BSF_RAGDOLLCONTROL:PreAssignRagdoll(net.ReadUInt(MAX_EDICT_BITS))
	--print(net.ReadUInt(MAX_EDICT_BITS))
end)

gameevent.Listen( "OnRequestFullUpdate" )
hook.Add( "OnRequestFullUpdate", "BSF_RAGDOLLCONTROL(AssignRagdoll)", function( data )
	timer.Simple(0,function()
		if(LocalPlayer():SteamID()==data.networkid)then
			if(IsValid(BSF_RAGDOLLCONTROL:GetRagdoll()))then
				BSF_RAGDOLLCONTROL:AssignRagdoll(BSF_RAGDOLLCONTROL:GetRagdoll())
			end
		end
	end)
end )


local function UnNormalizeAngle(ang)
	if(ang<0)then
		ang = 180 +(180+ang)
	end
	return ang
end

function BSF_RAGDOLLCONTROL:GetRagdoll()
	--return LocalPlayer():GetNWEntity("BSF_Ragdoll")
	return LocalPlayer().BSF_Ragdoll
end

hook.Add("Think","BSF_RAGDOLLCONTROL_BuildBones",function()
	--if(IsChanged(BSF_RAGDOLLCONTROL:GetRagdoll(),"BSF_Ragdoll",LocalPlayer()))then
	if(BSF_PreRagdoll and IsValid(Entity(BSF_PreRagdoll)))then
		BSF_RAGDOLLCONTROL:AssignRagdoll(Entity(BSF_PreRagdoll))
		BSF_PreRagdoll = nil
	end
end)

function BSF_RAGDOLLCONTROL:CalcAttackAngle(ply,x,y,mw)
	ply._BSF_AttackAngle = ply._BSF_AttackAngle or 0
	ply._BSF_AttackMouseWheel = mw
	ply._BSF_AttackSUM = ply._BSF_AttackSUM or 0
	if(ply._BSF_ChangeAttackAngleEndTime and ply._BSF_ChangeAttackAngleEndTime>CurTime())then
		--
	else
		ply._BSF_ChangeAttackAngleEndTime = nil
		if(math.abs(x)>BSF_RAGDOLLCONTROL_CV_AtkDirTol:GetInt() or math.abs(y)>BSF_RAGDOLLCONTROL_CV_AtkDirTol:GetInt())then
			local sum = math.abs(x)+math.abs(y)
			x = x/sum
			y = -y/sum
			
			if(x!=0 or y!=0) and sum!=0 then
				local ax = math.acos(x)
				local ay = math.asin(y)
				local ang = 0
				if(y>0)then
					--print(math.deg(ax))
					ang = math.deg(ax)
				else
					ang = -math.deg(ax)
				end
				if(BSF_RAGDOLLCONTROL_CV_InvertAtkDir:GetBool())then
					ang = ang + 180
				end
				local goodang = UnNormalizeAngle(ang)
				--ply._BSF_AttackAngle = goodang
				ply._BSF_AttackAngle = math.ApproachAngle(UnNormalizeAngle(ply._BSF_AttackAngle),goodang,sum/ply._BSF_AttackSUM*10)
				ply._BSF_AttackAngle = math.NormalizeAngle(ply._BSF_AttackAngle)
				--print(ply._BSF_AttackAngle)
				--ply._BSF_AttackAngle = ang
				ply._BSF_AttackSUM = sum
			end
		end
	end
end
hook.Add("StartCommand","BSF_RAGDOLLCONTROL",function(ply,cmd)
	BSF_RAGDOLLCONTROL:CalcAttackAngle(LocalPlayer(),cmd:GetMouseX(),cmd:GetMouseY(),cmd:GetMouseWheel())
end)

function BSF_RAGDOLLCONTROL:GetAttackAngle()
	LocalPlayer()._BSF_AttackAngle = LocalPlayer()._BSF_AttackAngle or 0
	return LocalPlayer()._BSF_AttackAngle,LocalPlayer()._BSF_AttackMouseWheel
end

function BSF_RAGDOLLCONTROL:SetAttackAngle(ang,time)
	LocalPlayer()._BSF_AttackAngle = ang
	LocalPlayer()._BSF_ChangeAttackAngleEndTime = CurTime()+time
end
net.Receive("BSF_RAGDOLLCONTROL(AttackAngle)",function()
	BSF_RAGDOLLCONTROL:SetAttackAngle(net.ReadInt(9),net.ReadUInt(4))
end)

function BSF_RAGDOLLCONTROL:CalcWeaponView(wep,view,newpos,newang,lerpspeed,lerpspeedpos)
	local framespeed = math.min(FrameTime()*lerpspeed,1)
	local framespeedpos
	if(lerpspeedpos)then
		framespeedpos = math.min(FrameTime()*lerpspeedpos,1)
	end
	
	LocalPlayer().BSF_LastView = LocalPlayer().BSF_LastView or view
	
	view.origin = LerpVector(framespeedpos or framespeed,LocalPlayer().BSF_LastView.origin,newpos)
	view.angles = LerpAngle(framespeed,LocalPlayer().BSF_LastView.angles,newang)
	
	return view
end

--//WVA - Weapon View Angle Offset
function BSF_RAGDOLLCONTROL:GetWVAChangeFraction(wepself)
	return math.min(FrameTime()*20,1)
end

function BSF_RAGDOLLCONTROL:GetWVDChangeFraction(wepself)
	return math.min(FrameTime()*20,1)
end

--[[

BSF_RAGDOLLCONTROL.BuildBonesFunc = function(rag,bonesnum)
	local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
	local mat = ent:GetBoneMatrix( bone )
	
	if(mat)then
		local scale = mat:GetScale()
		mat:Scale( vector_origin )
		ent:SetBoneMatrix( i, mat )
	end
end

function BSF_RAGDOLLCONTROL:AddBuildBonesCallBack(rag)
	if(rag._BSFBuildBonesCallBack)then
		rag:RemoveCallback("BuildBonePositions",rag._BSFBuildBonesCallBack)
	end
	
	rag._BSFBuildBonesCallBack = rag:AddCallback("BuildBonePositions",BSF_RAGDOLLCONTROL.BuildBonesFunc)
end
]]
--physenv.SetGravity(vector_origin)
function GM:CalcView( ply, pos, angles, fov )
	--print(ply.BSF_Ragdoll:GetPhysicsObject())
	--local rag = nil
	local rag = BSF_RAGDOLLCONTROL:GetRagdoll()
	if(IsValid(rag))then
		local retview = hook.Run("BSF(Pre_CalcView)",pos,angles,fov)	--Redo
		if(retview)then
			return retview
		end
		
		local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
		local bonepos = rag:GetBonePosition(bone)
		
		local expectedpos 
		local expectedangs
		
		angles = LocalPlayer():EyeAngles() + ply:GetViewPunchAngles()
		
		if(SWRD_Editor:IsOpened())then
			expectedpos=pos+angles:Forward()*70
			expectedangs=(-angles:Forward()):Angle()
		else
			if(!BSF_RAGDOLLCONTROL_CV_ViewThirdperson:GetBool())then
				--expectedpos=bonepos + angles:Up()*3
				LocalPlayer().BSF_LastWeaponViewAngles = LocalPlayer().BSF_LastWeaponViewAngles or angles
				local wepoffsetangs,wepoffsetdist,framespeed = hook.Run("BSF_CalcWeaponViewOffsetAngles",pos,LocalPlayer().BSF_LastWeaponViewAngles,fov)
				local headoffsetangs
				
				if(wepoffsetangs)then
					headoffsetangs = LerpAngle(framespeed or FrameTime(),LocalPlayer().BSF_LastWeaponViewAngles,wepoffsetangs)
					--LocalPlayer().BSF_LastWeaponViewAngles = headoffsetangs
				else
					headoffsetangs = Angle(angles)
					headoffsetangs:RotateAroundAxis(headoffsetangs:Right(),90)
					headoffsetangs = LerpAngle(framespeed or BSF_RAGDOLLCONTROL:GetWVAChangeFraction(nil),LocalPlayer().BSF_LastWeaponViewAngles,headoffsetangs)
					--LocalPlayer().BSF_LastWeaponViewAngles = headoffsetangs
				end
				
				LocalPlayer().BSF_LastWeaponViewAngles = headoffsetangs
				
				--if(wepoffsetdist)then
				LocalPlayer().BSF_LastWeaponViewOffsetDist = LocalPlayer().BSF_LastWeaponViewOffsetDist or 3
				--print(BSF_RAGDOLLCONTROL:GetWVDChangeFraction(nil))
				wepoffsetdist = Lerp(BSF_RAGDOLLCONTROL:GetWVDChangeFraction(nil),LocalPlayer().BSF_LastWeaponViewOffsetDist,wepoffsetdist or 3)
				--end
				
				LocalPlayer().BSF_LastWeaponViewOffsetDist = wepoffsetdist or 3
				
				expectedpos = bonepos + headoffsetangs:Forward()*(wepoffsetdist or 3)
				--[[
				if(wepoffsetangs)then
					expectedpos = bonepos + wepoffsetangs:Forward()*(wepoffsetdist or 3)
					LocalPlayer().BSF_LastWeaponViewAngles = wepoffsetangs
				else
					angles:RotateAroundAxis(angles:Right(),90)
					expectedpos = bonepos + angles:Forward()*3
					LocalPlayer().BSF_LastWeaponViewAngles = angles
					angles:RotateAroundAxis(angles:Right(),-90)	--Resetting
				end
				]]
			else
				expectedpos=bonepos + angles:Up()*16 + angles:Forward()*-64
			end
			expectedangs=angles
		end
		
		--expectedpos=pos
		local view = {
			origin = expectedpos,
			--origin = bonepos + angles:Up()*3,
			angles = expectedangs,
			fov = fov,
			drawviewer = false
		}
		
		local retview = hook.Run("BSF(CalcView)",view)
		if(retview)then
			view = retview
		end
		
		LocalPlayer().BSF_LastView = view

		return view
	end
end

function GM:RenderScene(origin,angles,fov)
	--print(origin)
	local rag = BSF_RAGDOLLCONTROL:GetRagdoll()
	if(IsValid(rag) and true)then
		local bone = rag:LookupBone("ValveBiped.Bip01_Head1")
		local bonepos = rag:GetBonePosition(bone)
	
		local expectedpos 
		local expectedangs
		
		if(SWRD_Editor:IsOpened())then
			expectedpos=pos+angles:Forward()*70
			expectedangs=(-angles:Forward()):Angle()
		else
			if(!BSF_RAGDOLLCONTROL_CV_ViewThirdperson:GetBool())then
				expectedpos=bonepos + angles:Up()*3
			else
				expectedpos=bonepos + angles:Up()*16 + angles:Forward()*-64
			end
			expectedangs=angles
		end
		
		angles[1] = expectedangs[1]
		angles[2] = expectedangs[2]
		angles[3] = expectedangs[3]
	
		origin[1] = expectedpos[1]
		origin[2] = expectedpos[2]
		origin[3] = expectedpos[3]
		--print(1,origin)
		--print(LocalPlayer():GetViewEntity())
	
		return false
	end
end

local function draw_Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

surface.CreateFont( "BSF_AmmoCount", {
	font = "Arial",
	extended = false,
	size = ScreenScale(15),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

hook.Add( "HUDPaint", "BSF_RAGDOLLCONTROL", function()
	local rag = BSF_RAGDOLLCONTROL:GetRagdoll()
	if(IsValid(rag))then
		local sizeW = ScreenScale(100)
		local sizeH = ScreenScale(30)
		
		local borders = 10
	
		--local hp = rag:GetNWFloat("BSF_Health")
		--local maxhp = rag:GetNWFloat("BSF_MaxHealth")
		local hp = LocalPlayer():Health()
		local maxhp = LocalPlayer():GetMaxHealth()
		local wide = hp/maxhp * (sizeW-borders*2)
		--print(hp)
		surface.SetDrawColor( 0, 0, 0, 128 )
		surface.DrawRect( 50, ScrH()-sizeH-70, sizeW, sizeH )
		surface.SetDrawColor( 150, 0, 0, 128 )
		surface.DrawRect( 50+borders, ScrH()-sizeH-70+borders, wide, sizeH-borders*2 )
		
		sizeW = ScreenScale(40)
		sizeH = ScreenScale(15)
		
		if(IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetMaxClip1()>0)then
			local ammo = LocalPlayer():GetActiveWeapon():Clip1().."/"..LocalPlayer():GetActiveWeapon():GetMaxClip1()
			surface.SetDrawColor( 0, 0, 0, 128 )
			surface.DrawRect( ScrW()-sizeW-250, ScrH()-sizeH-8, sizeW, sizeH )
			surface.SetFont( "BSF_AmmoCount" )
			local tw, th = surface.GetTextSize( ammo )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( ScrW()-sizeW-250+(sizeW-tw)/2, ScrH()-sizeH-8 )
			surface.DrawText( ammo )
		end
		
		BSF_CurAtkAng = BSF_CurAtkAng or 0
		local atkang,atkmw = BSF_RAGDOLLCONTROL:GetAttackAngle()
		
		local center = Vector( ScrW() / 2, ScrH() / 2 )

		atkang = math.NormalizeAngle(-atkang-90)
		--BSF_CurAtkAng = Lerp(RealFrameTime()*10,BSF_CurAtkAng,atkang)
		BSF_CurAtkAng = atkang

		local mat = Matrix()
		mat:Translate( center )
		mat:Rotate(Angle(0,BSF_CurAtkAng,0))
		cam.PushModelMatrix( mat )
			if(LocalPlayer()._BSF_ChangeAttackAngleEndTime)then
				surface.SetDrawColor( 150, 0, 0 )
			else
				surface.SetDrawColor( 255, 255, 255 )
			end
			surface.DrawLine( 0, 0, 1, 20 )
		cam.PopModelMatrix( )
		
		draw.NoTexture()
		draw_Circle(ScrW() / 2, ScrH() / 2,2,15)
	end
end )