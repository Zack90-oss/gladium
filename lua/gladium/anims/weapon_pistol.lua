BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] or {}
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] or {}

local weaponright = 0--3

--Aim
local mode = "arg_weapon_pistol(aim)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	
	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Head1"]
	local spinepos = b_spine4:GetPos()
	
	
	local ply = rag:GetOwner()
	
	local aimchange = BSF_RAGDOLLCONTROL:GetAimAngleChange(ply)
	--local aimchange = BSF_RAGDOLLCONTROL:GetAimAngleChangeCorrected(ply,0.99)*2
	
	local ang = ply:EyeAngles()+aimchange*3
	
	local aim = spinepos+ang:Forward()*22 + ang:Up()*-3.0 + ang:Right()*weaponright
	aim = aim + b_spine4:GetVelocity()*engine.TickInterval()*4.5
	
	ang = ang+aimchange*3
	
	local b_claviclel = rag.PhysBones["ValveBiped.Bip01_L_Clavicle"]
	local claviclelang = b_claviclel:GetAngles()
	
	local b_upperarml = rag.PhysBones["ValveBiped.Bip01_L_UpperArm"]
	local b_forearml = rag.PhysBones["ValveBiped.Bip01_L_Forearm"]
	local b_handl = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	
	
	local b_clavicle = rag.PhysBones["ValveBiped.Bip01_R_Clavicle"]
	local clavicleang = b_clavicle:GetAngles()
	
	local b_upperarm = rag.PhysBones["ValveBiped.Bip01_R_UpperArm"]
	local b_forearm = rag.PhysBones["ValveBiped.Bip01_R_Forearm"]
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	--_BSF_RAGDOLLCONTROL_shadow_data.maxangular = 100100

	if(ARG_Ent)then
		local curangs = Angle(ang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),0)
		curangs:RotateAroundAxis(curangs:Right(),0)
		curangs:RotateAroundAxis(curangs:Up(),0)
		BSF_RAGDOLLCONTROL:ControllPhysBone(ARG_Ent,aim,curangs)
	end
	--_BSF_RAGDOLLCONTROL_shadow_data.maxangular = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangular
	
	ARG_Ent = nil
end

--aim-hands
local mode = "weapon_pistol(aim-hands)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local time = rag._RagAnimStart[mode]
	
	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Head1"]
	local spinepos = b_spine4:GetPos()
	
	local ply = rag:GetOwner()
	
	local aimchange = BSF_RAGDOLLCONTROL:GetAimAngleChange(ply)
	
	local ang = ply:EyeAngles()+aimchange*3
	
	local aim = spinepos+ang:Forward()*21+ang:Up()*-0.0 + ang:Right()*weaponright
	aim = aim + b_spine4:GetVelocity()*engine.TickInterval()*4.5
	
	ang = ang+aimchange*3
	
	local b_claviclel = rag.PhysBones["ValveBiped.Bip01_L_Clavicle"]
	local claviclelang = b_claviclel:GetAngles()
	
	local b_upperarml = rag.PhysBones["ValveBiped.Bip01_L_UpperArm"]
	local b_forearml = rag.PhysBones["ValveBiped.Bip01_L_Forearm"]
	local b_handl = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	
	
	local b_clavicle = rag.PhysBones["ValveBiped.Bip01_R_Clavicle"]
	local clavicleang = b_clavicle:GetAngles()
	
	local b_upperarm = rag.PhysBones["ValveBiped.Bip01_R_UpperArm"]
	local b_forearm = rag.PhysBones["ValveBiped.Bip01_R_Forearm"]
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]

	if(time<0.5)then
		local passedtime = 0.0
		local waittime = 0.1
	
		local curangs = Angle(ang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(ply:EyeAngles():Forward(),180)
		curangs:RotateAroundAxis(ply:EyeAngles():Up(),0)
		curangs:RotateAroundAxis(ply:EyeAngles():Right(),0)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_hand:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,aim,curangs)	--Using positioning here
		--b_hand:SetPos(aim)
		--b_hand:SetAngles(curangs)
		--b_hand:Sleep()
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),130)
		curangs:RotateAroundAxis(curangs:Forward(),25)
		curangs:RotateAroundAxis(curangs:Up(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end

local mode = "weapon_pistol(reload)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"][mode] = 1.5	 -- Optional, but very useful for attack anims
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local time = rag._RagAnimStart[mode]
	
	local b_claviclel = rag.PhysBones["ValveBiped.Bip01_L_Clavicle"]
	local claviclelang = b_claviclel:GetAngles()
	
	local b_upperarml = rag.PhysBones["ValveBiped.Bip01_L_UpperArm"]
	local b_forearml = rag.PhysBones["ValveBiped.Bip01_L_Forearm"]
	local b_handl = rag.PhysBones["ValveBiped.Bip01_L_Hand"]
	
	local b_clavicle = rag.PhysBones["ValveBiped.Bip01_R_Clavicle"]
	local clavicleang = b_clavicle:GetAngles()
	
	local b_upperarm = rag.PhysBones["ValveBiped.Bip01_R_UpperArm"]
	local b_forearm = rag.PhysBones["ValveBiped.Bip01_R_Forearm"]
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]

	if(time<0.5)then
		local passedtime = 0.0
		local waittime = 0.5
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),114)
		curangs:RotateAroundAxis(curangs:Right(),6)
		curangs:RotateAroundAxis(curangs:Forward(),40)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-70)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),120)
		curangs:RotateAroundAxis(curangs:Right(),-5)
		curangs:RotateAroundAxis(curangs:Forward(),-10)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-95)
		curangs:RotateAroundAxis(curangs:Right(),15)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),-65)
		curangs:RotateAroundAxis(curangs:Up(),40)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	elseif(time<1.0)then
		local passedtime = 0.0
		local waittime = 1.0
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),154)
		curangs:RotateAroundAxis(curangs:Right(),6)
		curangs:RotateAroundAxis(curangs:Forward(),10)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-70)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),120)
		curangs:RotateAroundAxis(curangs:Right(),-5)
		curangs:RotateAroundAxis(curangs:Forward(),-10)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-95)
		curangs:RotateAroundAxis(curangs:Right(),15)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),-65)
		curangs:RotateAroundAxis(curangs:Up(),40)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end