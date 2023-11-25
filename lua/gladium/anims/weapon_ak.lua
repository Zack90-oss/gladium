BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] or {}
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] or {}

local weapondist = 19
local weaponright = 4

--Aim
local mode = "arg_weapon_ak(aim)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	
	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Head1"]
	local spinepos = b_spine4:GetPos()
	
	local ply = rag:GetOwner()

	local aimchange = BSF_RAGDOLLCONTROL:GetAimAngleChange(ply)
	
	local ang = ply:EyeAngles()+aimchange*3
	
	local aim = spinepos+ang:Forward()*weapondist+ang:Up()*-7.0+ang:Right()*(1.0+weaponright)
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

--Aim
local mode = "weapon_ak(aim-hands)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local time = rag._RagAnimStart[mode]
	
	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Head1"]
	local spinepos = b_spine4:GetPos()
	
	local ply = rag:GetOwner()

	local aimchange = BSF_RAGDOLLCONTROL:GetAimAngleChange(ply)
	
	local ang = ply:EyeAngles()+aimchange*3
	
	local aim = spinepos+ang:Forward()*(weapondist-13)+ang:Up()*-7.0+ang:Right()*(2.0+weaponright)
	aim = aim + b_spine4:GetVelocity()*engine.TickInterval()*4.5
	local aim2 = spinepos+ang:Forward()*(weapondist-2)+ang:Up()*-7.0+ang:Right()*(-1.0+weaponright)
	aim2 = aim2 + b_spine4:GetVelocity()*engine.TickInterval()*4.5
	
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
	
		--Right Hand
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
		local curangs = Angle(ang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(ply:EyeAngles():Forward(),0)
		curangs:RotateAroundAxis(ply:EyeAngles():Up(),0)
		curangs:RotateAroundAxis(ply:EyeAngles():Right(),0)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,aim2,curangs)	--Using positioning here
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end

local mode = "weapon_ak(idle)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local time = rag._RagAnimStart[mode]
	
	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Head1"]
	local spinepos = b_spine4:GetPos()
	
	local ply = rag:GetOwner()
	local aim = spinepos+ply:GetAimVector()*22+ply:EyeAngles():Up()*-3.0
	
	--aim = aim + rag:GetVelocity()
	
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
	if(time<0.5)then
		local passedtime = 0.0
		local waittime = 0.1

		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),160)
		curangs:RotateAroundAxis(claviclelang:Forward(),20)
		curangs:RotateAroundAxis(claviclelang:Right(),-20)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-115)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		local _curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(_curangs:Right(),5)
		curangs:RotateAroundAxis(_curangs:Forward(),-15)
		curangs:RotateAroundAxis(_curangs:Up(),10)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),165)
		curangs:RotateAroundAxis(clavicleang:Forward(),30)
		curangs:RotateAroundAxis(clavicleang:Right(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-125)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),-55)
		curangs:RotateAroundAxis(curangs:Up(),10)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
		
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
end

local mode = "weapon_ak(stab)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"][mode] = 0.2	 -- Optional, but very useful for attack anims
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local time = rag._RagAnimStart[mode]
	
	local b_clavicle = rag.PhysBones["ValveBiped.Bip01_R_Clavicle"]
	local clavicleang = b_clavicle:GetAngles()
	
	local b_upperarm = rag.PhysBones["ValveBiped.Bip01_R_UpperArm"]
	local b_forearm = rag.PhysBones["ValveBiped.Bip01_R_Forearm"]
	local b_hand = rag.PhysBones["ValveBiped.Bip01_R_Hand"]
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = 0.1

	if(time<0.2)then
		local passedtime = 0.0
		local waittime = 0.1
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),0)
		curangs:RotateAroundAxis(curangs:Forward(),20 - 45)--Subtracting 45 so matches with core movement
		curangs:RotateAroundAxis(curangs:Up(),75)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_upperarm:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),180)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_forearm:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-20)
		curangs:RotateAroundAxis(curangs:Forward(),65)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_hand:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end


local mode = "weapon_ak(reload)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"][mode] = 2.0	 -- Optional, but very useful for attack anims
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
		local waittime = 0.1
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),104)
		curangs:RotateAroundAxis(curangs:Right(),6)
		curangs:RotateAroundAxis(curangs:Forward(),50)
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
		curangs:RotateAroundAxis(curangs:Up(),170)
		curangs:RotateAroundAxis(curangs:Right(),-5)
		curangs:RotateAroundAxis(curangs:Forward(),-10)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-145)
		curangs:RotateAroundAxis(curangs:Right(),35)
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
		local passedtime = 0.5
		local waittime = 0.1
		
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
		curangs:RotateAroundAxis(curangs:Up(),170)
		curangs:RotateAroundAxis(curangs:Right(),-5)
		curangs:RotateAroundAxis(curangs:Forward(),-10)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-145)
		curangs:RotateAroundAxis(curangs:Right(),35)
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
	elseif(time<1.5)then
		local passedtime = 1.0
		local waittime = 0.1
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),104)
		curangs:RotateAroundAxis(curangs:Right(),6)
		curangs:RotateAroundAxis(curangs:Forward(),50)
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
		curangs:RotateAroundAxis(curangs:Up(),170)
		curangs:RotateAroundAxis(curangs:Right(),-5)
		curangs:RotateAroundAxis(curangs:Forward(),-10)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-145)
		curangs:RotateAroundAxis(curangs:Right(),35)
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
	elseif(time<1.7)then
		local passedtime = 1.5
		local waittime = 0.1
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),104)
		curangs:RotateAroundAxis(curangs:Right(),6)
		curangs:RotateAroundAxis(curangs:Forward(),50)
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
		curangs:RotateAroundAxis(curangs:Up(),190)
		curangs:RotateAroundAxis(curangs:Right(),-55)
		curangs:RotateAroundAxis(curangs:Forward(),50)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-145)
		curangs:RotateAroundAxis(curangs:Right(),35)
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
	elseif(time<2.0)then
		local passedtime = 1.7
		local waittime = 0.1
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),54)
		curangs:RotateAroundAxis(curangs:Right(),-10)
		curangs:RotateAroundAxis(curangs:Forward(),130)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-80)
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
		curangs:RotateAroundAxis(curangs:Up(),190)
		curangs:RotateAroundAxis(curangs:Right(),-55)
		curangs:RotateAroundAxis(curangs:Forward(),50)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-145)
		curangs:RotateAroundAxis(curangs:Right(),35)
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
