BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] or {}
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] or {}

--Idle
local mode = "weapon_fists(idle)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"][mode] = 0.5	 -- Optional, but very useful for attack anims
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
	
	--Changing angular speed to custom
	--local defmass = b_handl:GetMass()
	--b_handl:SetMass(11110)
	--_BSF_RAGDOLLCONTROL_shadow_data.maxangular = 9800
	--_BSF_RAGDOLLCONTROL_shadow_data.maxangulardamp = 9800*511
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = .8

	if(time<0.5)then
		local passedtime = 0.0
		local waittime = 0.1
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),90)
		curangs:RotateAroundAxis(curangs:Forward(),25)
		curangs:RotateAroundAxis(curangs:Up(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_upperarml:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-125)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_forearml:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Up(),-115)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_handl:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),120)
		curangs:RotateAroundAxis(curangs:Forward(),-25)
		curangs:RotateAroundAxis(curangs:Up(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_upperarm:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-125)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_forearm:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Up(),-115)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_hand:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--Reseting angular speed to default
	--b_handl:SetMass(defmass)
	--_BSF_RAGDOLLCONTROL_shadow_data.maxangular = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangular
	--_BSF_RAGDOLLCONTROL_shadow_data.maxangulardamp = _BSF_RAGDOLLCONTROL_default_shadow_data.maxangulardamp
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end

--Punch Left
local mode = "weapon_fists(punch_left)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"][mode] = 0.2	 -- Optional, but very useful for attack anims
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local time = rag._RagAnimStart[mode]
	
	local b_claviclel = rag.PhysBones["ValveBiped.Bip01_L_Clavicle"]
	local claviclelang = b_claviclel:GetAngles()
	
	local b_upperarml = rag.PhysBones["ValveBiped.Bip01_L_UpperArm"]
	local b_forearml = rag.PhysBones["ValveBiped.Bip01_L_Forearm"]
	local b_handl = rag.PhysBones["ValveBiped.Bip01_L_Hand"]

	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = 0.1

	if(time<0.2)then
		local passedtime = 0.0
		local waittime = 0.1
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),-60)
		curangs:RotateAroundAxis(curangs:Forward(),-54 + 30)--Adding 30 so matches with core movement
		curangs:RotateAroundAxis(curangs:Up(),45)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_upperarml:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Right(),90)
		curangs:RotateAroundAxis(curangs:Forward(),180)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_forearml:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Up(),-115)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_handl:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end

--Punch Left
local mode = "weapon_fists(punch_right)"
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
		curangs:RotateAroundAxis(curangs:Forward(),20 - 35)--Subtracting 35 so matches with core movement
		curangs:RotateAroundAxis(curangs:Up(),45)
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
		--curangs:RotateAroundAxis(curangs:Up(),-115)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_hand:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end