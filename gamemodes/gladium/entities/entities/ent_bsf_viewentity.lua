AddCSLuaFile()
ENT.PrintName =  ""
ENT.Type = "point"


function ENT:Initialize()

end

function ENT:UpdateTransmitState()	
	return TRANSMIT_PVS
end

function ENT:OnRemove( )
	--
end