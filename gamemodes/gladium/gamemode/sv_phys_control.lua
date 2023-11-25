BSF_PHYSCONTROL = BSF_PHYSCONTROL or {}

--Phys Collide Callback
BSF_PHYSCONTROL._CollideFunc = function(ent,data)
	hook.Run("BSF_PHYSCONTROL(PhysicsCollide)",ent,data)
end

function BSF_PHYSCONTROL:AddPhysCollideCallBack(ent)
	if(ent._BSFPhysCollideCallback)then
		ent:RemoveCallback("PhysicsCollide",ent._BSFPhysCollideCallback)
	end
	
	ent._BSFPhysCollideCallback = ent:AddCallback("PhysicsCollide",BSF_PHYSCONTROL._CollideFunc)
end