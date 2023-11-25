BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"] or {}

--Legs IDLE
local mode = "idle"
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local b_pelvis = rag.PhysBones["ValveBiped.Bip01_Pelvis"]
	local pelvisang = b_pelvis:GetAngles()

	local time = rag._RagAnimStart[mode]
	local b_thigh = rag.PhysBones["ValveBiped.Bip01_L_Thigh"]
	local b_calf = rag.PhysBones["ValveBiped.Bip01_L_Calf"]
	local b_thighr = rag.PhysBones["ValveBiped.Bip01_R_Thigh"]
	local b_calfr = rag.PhysBones["ValveBiped.Bip01_R_Calf"]
	
	local b_toe = rag.PhysBones["ValveBiped.Bip01_L_Foot"]	--Not a toe actually
	local b_toer = rag.PhysBones["ValveBiped.Bip01_R_Foot"]
	
	if(time<0.5)then
		local passedtime = 0.0
		
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] - 52
		curangs[2] = b_toe:GetAngles()[2]
		curangs[3] = b_toe:GetAngles()[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toe:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] - 52
		curangs[2] = b_toer:GetAngles()[2]
		curangs[3] = b_toer:GetAngles()[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toer:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end

--Walk FORWARD
local mode = IN_FORWARD
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local b_pelvis = rag.PhysBones["ValveBiped.Bip01_Pelvis"]
	local pelvisang = b_pelvis:GetAngles()

	local time = rag._RagAnimStart[mode]
	local b_thigh = rag.PhysBones["ValveBiped.Bip01_L_Thigh"]
	local b_calf = rag.PhysBones["ValveBiped.Bip01_L_Calf"]
	local b_thighr = rag.PhysBones["ValveBiped.Bip01_R_Thigh"]
	local b_calfr = rag.PhysBones["ValveBiped.Bip01_R_Calf"]
	
	local b_toe = rag.PhysBones["ValveBiped.Bip01_L_Toe0"]
	local b_toer = rag.PhysBones["ValveBiped.Bip01_R_Toe0"]
	
	if(time<0.5)then--First Move
		local passedtime = 0.0
		
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 -60
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toe:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 + 60
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] +100
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] + 90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toer:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	
	
	elseif(time<1.0)then--Left leg curve and lean forward
		local passedtime = 0.5
	
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 + 60
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+100
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		--print(curangs)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toe:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 - 60
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] --+ BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,0.5,0.5,true)* -90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] --+ BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,0.5,0.5,true)*90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toer:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end

--Walk BACK
local mode = IN_BACK
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local b_pelvis = rag.PhysBones["ValveBiped.Bip01_Pelvis"]
	local pelvisang = b_pelvis:GetAngles()

	local time = rag._RagAnimStart[mode]
	local b_thigh = rag.PhysBones["ValveBiped.Bip01_L_Thigh"]
	local b_calf = rag.PhysBones["ValveBiped.Bip01_L_Calf"]
	local b_thighr = rag.PhysBones["ValveBiped.Bip01_R_Thigh"]
	local b_calfr = rag.PhysBones["ValveBiped.Bip01_R_Calf"]
	
	local b_toe = rag.PhysBones["ValveBiped.Bip01_L_Toe0"]
	local b_toer = rag.PhysBones["ValveBiped.Bip01_R_Toe0"]
	
	if(time<0.5)then--First Move
		local passedtime = 0.0
		local waittime = 0.5
		
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 -50
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]-40
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_toe:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 + 50
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+70
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] + 90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_toer:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	
	
	elseif(time<1.0)then--Left leg curve and lean forward
		local passedtime = 0.5
		local waittime = 0.5
	
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 + 50
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+70
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_toe:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90 -50
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]-40 --+ BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,0.5,0.5,true)* -90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]+90 --+ BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,0.5,0.5,true)*90
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,waittime,false),b_toer:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end

--Walk LEFT
local mode = IN_MOVELEFT
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets["default"][mode] = function(rag)
	local b_pelvis = rag.PhysBones["ValveBiped.Bip01_Pelvis"]
	local pelvisang = b_pelvis:GetAngles()

	local time = rag._RagAnimStart[mode]
	local b_thigh = rag.PhysBones["ValveBiped.Bip01_L_Thigh"]
	local b_calf = rag.PhysBones["ValveBiped.Bip01_L_Calf"]
	local b_thighr = rag.PhysBones["ValveBiped.Bip01_R_Thigh"]
	local b_calfr = rag.PhysBones["ValveBiped.Bip01_R_Calf"]
	
	local b_toe = rag.PhysBones["ValveBiped.Bip01_L_Toe0"]
	local b_toer = rag.PhysBones["ValveBiped.Bip01_R_Toe0"]
	
	if(time<0.5)then--First Move
		local passedtime = 0.0
		local waittime = 0.5
		
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Right(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Right(),45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] - 52
		curangs[2] = b_toe:GetAngles()[2]
		curangs[3] = b_toe:GetAngles()[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toe:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs:RotateAroundAxis(curangs:Right(),-45)
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] - 52
		curangs[2] = b_toer:GetAngles()[2]
		curangs[3] = b_toer:GetAngles()[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toer:GetAngles(),curangs)
		--BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	
	
	elseif(time<1.0)then--Left leg curve and lean forward
		local passedtime = 0.5
	
		--Left Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thigh:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thigh,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_calf:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calf,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] - 52
		curangs[2] = b_toe:GetAngles()[2]
		curangs[3] = b_toe:GetAngles()[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toe:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toe,nil,curangs)
		
		--Right Leg
		local curangs = Angle(pelvisang)
		curangs[1] = curangs[1]+90
		curangs[2] = curangs[2]+90
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_thighr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_thighr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1]
		curangs[2] = curangs[2]
		curangs[3] = curangs[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.3,false),b_calfr:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_calfr,nil,curangs)
		
		local curangs = Angle(curangs)
		curangs[1] = curangs[1] - 52
		curangs[2] = b_toer:GetAngles()[2]
		curangs[3] = b_toer:GetAngles()[3]
		curangs = LerpAngle(BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,passedtime,0.5,false),b_toer:GetAngles(),curangs)
		BSF_RAGDOLLCONTROL:ControllPhysBone(b_toer,nil,curangs)
	else
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)
	end
end