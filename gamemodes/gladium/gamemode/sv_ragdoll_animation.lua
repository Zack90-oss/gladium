BSF_RAGDOLLCONTROL_ANIMATION = BSF_RAGDOLLCONTROL_ANIMATION or {}

--\\Registration

BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets or {}
BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime = BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime or {} -- Optional, but very useful for attack anims

function BSF_RAGDOLLCONTROL_ANIMATION:ReloadAnimations()
	local rootFolder = "gladium/anims/"
	
	print("BSF: Reloading Animations")
	print(rootFolder)

	local files, _ = file.Find( rootFolder..'*', "LUA" )
	for _,filename in pairs(files)do
		include(rootFolder..'/'..filename)
	end
end
BSF_RAGDOLLCONTROL_ANIMATION:ReloadAnimations()

--//

--\\Utils

function BSF_RAGDOLLCONTROL_ANIMATION:Anim_Gettimemul(time,endtime)
	return time/endtime
end

function BSF_RAGDOLLCONTROL_ANIMATION:Anim_GetTimeLerp(time,minus,goal,inverted)
	if(inverted)then
		return math.max((1-BSF_RAGDOLLCONTROL_ANIMATION:Anim_Gettimemul(time-minus,goal)),0)
	else
		return math.min(BSF_RAGDOLLCONTROL_ANIMATION:Anim_Gettimemul(time-minus,goal),1)
	end
end

function BSF_RAGDOLLCONTROL_ANIMATION:Anim_ApproachAngle(ang,goalang,rate)
	return Angle( math.ApproachAngle(ang[1],goalang[1],rate),math.ApproachAngle(ang[2],goalang[2],rate),math.ApproachAngle(ang[3],goalang[3],rate) )
end

--//

BSF_RAGDOLLCONTROL_ANIMATION.AnimEventsRagThink = function(rag)						--; TODO
	rag._AnimEvents = rag._AnimEvents or {}

	local count = 0
	for event,time in pairs(rag._AnimEvents)do
		count = count + 1
		if(time!=CurTime())then
			rag._AnimEvents[event] = nil
			count = count - 1
		end
	end
	if(count==0)then
		--hook.Remove("Think",rag)	--; Allah-Allah..
	end
end
hook.Add("BSF_RAGDOLLCONTROL(PostBodyAnimation)","BSF_RAGDOLLCONTROL_ANIMATION.AnimEventsRagThink",BSF_RAGDOLLCONTROL_ANIMATION.AnimEventsRagThink)

function BSF_RAGDOLLCONTROL_ANIMATION:AnimateEventTrigger(rag,event)				--Writes animation event on ragdoll for 1 server tick; To read in "Think"-like hooks, Use inside (animation) functions
	rag._AnimEvents = rag._AnimEvents or {}
	rag._AnimEvents[event] = CurTime()
	--hook.Add("Think",rag,BSF_RAGDOLLCONTROL_ANIMATION.AnimEventsRagThink)	--; Allah-Allah, CONFLICT REDO
end

function BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,anim,rate,animset)				--Animates ragdoll; Use this only with continious animations. For animations like weapon reloads use BSF_RAGDOLLCONTROL:ResetAnimation
	rag._RagAnimStart = rag._RagAnimStart or {}
	rag._RagAnimStart_LastCall = rag._RagAnimStart_LastCall or {}
	
	
	local delta = CurTime()-(rag._RagAnimStart_LastCall[anim] or CurTime())
	delta = delta * (rate or 1)
	
	--[[
	if(anim=="weapon_axe(slash-right)")then
		print(CurTime(),rag._RagAnimStart_LastCall[anim],delta)
	end
	]]
	
	rag._RagAnimStart[anim] = (rag._RagAnimStart[anim] or 0) + delta
	rag._RagAnimStart_LastCall[anim] = CurTime()
	
	
	BSF_RAGDOLLCONTROL_ANIMATION.AnimationSets[animset or "default"][anim](rag)
end

function BSF_RAGDOLLCONTROL_ANIMATION:GetAnimTime(rag,anim,rate,animset)
	animset = animset or "default"
	rate = rate or 1
	return BSF_RAGDOLLCONTROL_ANIMATION.AnimationSetsReportedTime[animset][anim]/rate
end

--\\Animations Resets

function BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset(rag,mode)					--Tells BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag() to reset anim cycle; Usualy called in (animation) functions
	hook.Run("BSF_RAGDOLLCONTROL_ANIMATION(Pre_AnimationReset)",rag,mode)
	rag._RagAnimStart = rag._RagAnimStart or {}
	rag._RagAnimStart_LastCall = rag._RagAnimStart_LastCall or {}
	rag._RagAnimStart[mode] = nil
	rag._RagAnimStart_LastCall[mode] = nil
	
	rag._BSF_RagAnimationsPlaying = rag._BSF_RagAnimationsPlaying or {}
	rag._BSF_RagAnimationsPlaying[mode] = nil
	hook.Run("BSF_RAGDOLLCONTROL_ANIMATION(AnimationReset)",rag,mode)
end

function BSF_RAGDOLLCONTROL_ANIMATION:ResetAnimation(rag,anim,rate,animset,args)	--Starts animation from cycle 0 and then plays it until in ends; Plays animation until BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag_Reset call (Call this once and animation will play until it stops)
	rag._BSF_RagAnimationsPlaying = rag._BSF_RagAnimationsPlaying or {}
	rag._BSF_RagAnimationsPlaying[anim] = {
		Rate = rate,
		Animset = animset,
		Args = args,
	}
end

--//

function BSF_RAGDOLLCONTROL_ANIMATION:IsAnimating(rag,anim)							--; Self explanatory
	rag._BSF_RagAnimationsPlaying = rag._BSF_RagAnimationsPlaying or {}
	return rag._BSF_RagAnimationsPlaying[anim]~=nil
end

BSF_RAGDOLLCONTROL_ANIMATION.AnimationsThink = function(rag,eyeangs,footbase,additiveeyeangs)
	rag._BSF_RagAnimationsPlaying = rag._BSF_RagAnimationsPlaying or {}
	for anim, info in pairs(rag._BSF_RagAnimationsPlaying)do
		if(info.Args)then
			for arg,val in pairs(info.Args)do
				RunString(arg.."="..val)
			end
		end
		BSF_RAGDOLLCONTROL_ANIMATION:AnimateRag(rag,anim,info.Rate,info.Animset)
	end
end
hook.Add("BSF_RAGDOLLCONTROL(PostBodyAnimation)","BSF_RAGDOLLCONTROL_ANIMATION.AnimationsThink",BSF_RAGDOLLCONTROL_ANIMATION.AnimationsThink)