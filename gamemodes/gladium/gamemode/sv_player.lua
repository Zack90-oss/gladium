local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:GiveBSFWeapon(wepclass)
	BSF_RAGDOLLCONTROL_WEAPONS:GiveWeapon(self,wepclass)
end

function PlayerMeta:StripBSFWeapon(wepclass)
	BSF_RAGDOLLCONTROL_WEAPONS:StripWeapon(self,wepclass)
end

function PlayerMeta:StripBSFWeapons()
	BSF_RAGDOLLCONTROL_WEAPONS:StripWeapons(self)
end

function PlayerMeta:SetBSFHealth(hp)
	self.BSF_Ragdoll:SetNWFloat("BSF_Health",hp)
end

function PlayerMeta:SetBSFPos(pos)
	for i=0, self.BSF_Ragdoll:GetPhysicsObjectCount() - 1 do
		local phys = self.BSF_Ragdoll:GetPhysicsObjectNum(i)
		phys:SetPos(pos)
	end
end

function PlayerMeta:GiveLoadout(loadout)

end

function PlayerMeta:GetRagPos()
	local pos = self.BSF_Ragdoll:GetPos()
	local res = "Vector("..math.Round(pos.x,0)..","..math.Round(pos.y,0)..","..math.Round(pos.z+5,0)..")"
	return res
end

function PlayerMeta:GetRagAngles()
	local ang = self:GetAngles()
	local res = "Angle("..math.Round(ang[1],0)..","..math.Round(ang[2],0)..","..math.Round(ang[3],0)..")"
	return res
end

local t_ragposes = {}
function BSF_AddRagPos(ply,tname)
	t_ragposes[tname] = t_ragposes[tname] or {}
	local pos = ply.BSF_Ragdoll:GetPos()
	local ang = ply:GetAngles()
	t_ragposes[tname][#t_ragposes[tname]+1] = {Pos = pos,Ang = ang}
end

function BSF_WriteRagPoses()
	print("util.JSONToTable([["..util.TableToJSON(t_ragposes,true).."]])")
	t_ragposes = {}
end

function PlayerMeta:ApplyShock(Amount)
	Amount = math.Round(Amount)
	self:SetNWInt("Shock",self:GetNWInt("Shock",0) + Amount)
end

function PlayerMeta:CanStand()
	if(false)then
		return false
	end
	return true
end