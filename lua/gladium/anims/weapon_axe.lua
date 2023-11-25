BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] or {}
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"] or {}

--//Idle
local mode = "arg_weapon_axe(idle)"
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
		--[[
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),0)
		curangs:RotateAroundAxis(curangs:Right(),0)
		curangs:RotateAroundAxis(curangs:Up(),0)
		BSF_RAGDOLLCONTROL:ControllPhysBone(ARG_Ent,ARG_Pos,nil)
		]]
		ARG_Pos = nil
		ARG_Ent = nil
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),80+75)
		curangs:RotateAroundAxis(claviclelang:Forward(),-15)
		curangs:RotateAroundAxis(claviclelang:Right(),-40)
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
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),75)
		curangs:RotateAroundAxis(curangs:Forward(),95)
		curangs:RotateAroundAxis(curangs:Up(),10)
		curangs:RotateAroundAxis(curangs:Right(),-60)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),100+35)
		curangs:RotateAroundAxis(clavicleang:Forward(),-5)
		curangs:RotateAroundAxis(clavicleang:Right(),35)
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
		--curangs:RotateAroundAxis(curangs:Forward(),85)
		curangs:RotateAroundAxis(curangs:Up(),90)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
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

--//arg-weapon_axe(corrective_atkdir)		--"arg" means needs global argument input, here ARG_Tilt
local mode = "arg-weapon_axe(corrective_atkdir)"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime["default"][mode] = 0.5	 -- Optional, but very useful for attack anims
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	ARG_Tilt = ARG_Tilt or 0
	local ply = rag:GetOwner()
	local eyeangs = ply:EyeAngles()

	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Spine4"]
	local b_spine4ang = b_spine4:GetAngles()

	--Spine 4
	local cureyeangs = Angle(eyeangs)
	cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
	cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
	cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
	cureyeangs:RotateAroundAxis(b_spine4ang:Forward(),ARG_Tilt)
	BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)

	ARG_Tilt = nil	--Free the memory
end

--//Stab
local mode = "weapon_axe(stab)"
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
		curangs:RotateAroundAxis(curangs:Up(),95)
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
		--curangs:RotateAroundAxis(curangs:Forward(),85)
		curangs:RotateAroundAxis(curangs:Up(),90)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end
--[[
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

	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = 0.1

	if(time<0.2)then
		local passedtime = 0.0
		local waittime = 0.1

		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),90)
		curangs:RotateAroundAxis(curangs:Forward(),0)
		curangs:RotateAroundAxis(curangs:Right(),-25)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_upperarm:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-0)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_forearm:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-90)
		curangs:RotateAroundAxis(curangs:Forward(),0)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		--curangs = BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(b_hand:GetAngles(),curangs,80)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)

		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),140)
		curangs:RotateAroundAxis(curangs:Forward(),-25)
		curangs:RotateAroundAxis(curangs:Up(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarm:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-125)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearm:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),-65)
		curangs:RotateAroundAxis(curangs:Up(),40)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,b_hand:GetAngles())		
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end
]]

--//Slash Right
local mode = "weapon_axe(slash-right)"
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
	
	local ply = rag:GetOwner()
	local eyeangs = ply:EyeAngles()

	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Spine4"]
	local b_spine4ang = b_spine4:GetAngles()

	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = 0.1

	if(time<0.20)then
		local passedtime = 0.0
		local waittime = 0.2
		
		--Spine 4
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
		cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
		cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
		cureyeangs:RotateAroundAxis(b_spine4ang:Forward(),-60)
		--cureyeangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_spine4:GetAngles(),cureyeangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),80)
		curangs:RotateAroundAxis(claviclelang:Forward(),45)
		curangs:RotateAroundAxis(claviclelang:Up(),115)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-95)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),75)
		curangs:RotateAroundAxis(curangs:Forward(),95)
		curangs:RotateAroundAxis(curangs:Up(),10)
		curangs:RotateAroundAxis(curangs:Right(),-60)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),150)
		curangs:RotateAroundAxis(clavicleang:Forward(),10)
		curangs:RotateAroundAxis(clavicleang:Right(),40)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),90)
		curangs:RotateAroundAxis(curangs:Up(),-120)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),20)
		curangs:RotateAroundAxis(curangs:Forward(),0)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	elseif(time<0.5)then
		local passedtime = 0.5
		local waittime = 0.2
		
		--Spine 4
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
		cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
		cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
		cureyeangs:RotateAroundAxis(b_spine4ang:Forward(),30)
		--cureyeangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_spine4:GetAngles(),cureyeangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)
		
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),60)
		curangs:RotateAroundAxis(claviclelang:Forward(),45)
		curangs:RotateAroundAxis(claviclelang:Up(),95)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-125)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),75)
		curangs:RotateAroundAxis(curangs:Forward(),95)
		curangs:RotateAroundAxis(curangs:Up(),10)
		curangs:RotateAroundAxis(curangs:Right(),-60)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,b_handl:GetAngles())
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Right(),60)
		curangs:RotateAroundAxis(clavicleang:Forward(),0)
		curangs:RotateAroundAxis(clavicleang:Up(),-10)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),90)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),85)
		curangs:RotateAroundAxis(curangs:Up(),40)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end

--//Slash Left
local mode = "weapon_axe(slash-left)"
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
	
	local ply = rag:GetOwner()
	local eyeangs = ply:EyeAngles()

	local b_spine4 = rag.PhysBones["ValveBiped.Bip01_Spine4"]
	local b_spine4ang = b_spine4:GetAngles()

	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = 0.1

	if(time<0.20)then
		local passedtime = 0.0
		local waittime = 0.2
		
		--Spine 4
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
		cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
		cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
		cureyeangs:RotateAroundAxis(b_spine4ang:Forward(),60)
		--cureyeangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_spine4:GetAngles(),cureyeangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)
		--[[
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Up(),-20)
		curangs:RotateAroundAxis(curangs:Forward(),30)
		curangs:RotateAroundAxis(curangs:Up(),25)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),30)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),0)
		curangs:RotateAroundAxis(curangs:Forward(),90)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
]]
		--Left Hand
		local curangs = Angle(claviclelang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(claviclelang:Up(),80)
		curangs:RotateAroundAxis(claviclelang:Forward(),45)
		curangs:RotateAroundAxis(claviclelang:Up(),95)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_upperarml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Up(),-125)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_forearml:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearml,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),75)
		curangs:RotateAroundAxis(curangs:Forward(),95)
		curangs:RotateAroundAxis(curangs:Up(),10)
		curangs:RotateAroundAxis(curangs:Right(),-60)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_handl:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_handl,nil,b_handl:GetAngles())
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Right(),40)
		curangs:RotateAroundAxis(clavicleang:Forward(),0)
		curangs:RotateAroundAxis(clavicleang:Up(),40)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),90)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),85)
		curangs:RotateAroundAxis(curangs:Up(),40)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	elseif(time<0.5)then
		local passedtime = 0.5
		local waittime = 0.2
		
		--Spine 4
		local cureyeangs = Angle(eyeangs)
		cureyeangs[1] = math.Clamp(cureyeangs[1]-10,-40,40)
		cureyeangs:RotateAroundAxis(cureyeangs:Forward(),-90)
		cureyeangs:RotateAroundAxis(cureyeangs:Up(),-90)
		cureyeangs:RotateAroundAxis(b_spine4ang:Forward(),-50)
		--cureyeangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_spine4:GetAngles(),cureyeangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_spine4,nil,cureyeangs)
		
		--Right Hand
		local curangs = Angle(clavicleang)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(clavicleang:Right(),30)
		curangs:RotateAroundAxis(clavicleang:Forward(),0)
		curangs:RotateAroundAxis(clavicleang:Up(),40)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_upperarm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Forward(),90)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_forearm,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--curangs:RotateAroundAxis(curangs:Forward(),85)
		curangs:RotateAroundAxis(curangs:Up(),90)
		--curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_hand:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_hand,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
	
	--_BSF_RAGDOLLCONTROL_shadow_data.dampfactor = _BSF_RAGDOLLCONTROL_default_shadow_data.dampfactor
end