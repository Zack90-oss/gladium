AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName		= "Piece"

function ENT:Initialize()
	self.Entity:SetModel(self.PieceModel or "models/dimension/terrain_flat.mdl")
	--self.Entity:SetModelScale(0.1)
	if(SERVER)then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
--MOVETYPE_VPHYSICS
	
		local phys = self:GetPhysicsObject()
		if(IsValid(phys))then
			phys:SetMass(self.ProjMass or 6)
		end
	end
end

function ENT:Think()
	
end