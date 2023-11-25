GLADIUM={}
GLADIUM.AnimVersion=1
GLADIUM.AnimPath="_swords_anims/"
GLADIUM.NextLeanTime=0
--SWORDS.LeanCoolDown=0.2

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_player.lua" )
AddCSLuaFile( "cl_swordeditor.lua" )


AddCSLuaFile( "cl_ragdoll_control.lua" )

AddCSLuaFile( "cl_ragdoll_weapons.lua" )

include( "sv_stuff.lua" )
include( "sv_player.lua" )
include( "sv_ragdoll.lua" )

AddCSLuaFile( "shared.lua" )
include( "shared.lua" )


//AFTER SHARED.LUA

hook.Add( "PlayerUse", "BSF", function( ply, ent )
	if(ent.BSF_PreventUse)then
		return false
	end
end )

function GM:Initialize()
	RegisterLangs()
end

function GM:Think()

end

function GM:EntityTakeDamage( ply, dmginfo )
	if(!ply:IsPlayer())then return end
	local hitgroup = dmginfo:GetDamageCustom()
	if(hitgroup==0)then
		hitgroup = HITGROUP_CHEST
	end
	
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
		dmginfo:SetDamageBonus( dmginfo:GetDamageBonus()*1.6 )
	end
	if ( hitgroup == HITGROUP_CHEST ) then
		dmginfo:ScaleDamage( 1.1 )
		dmginfo:SetDamageBonus( dmginfo:GetDamageBonus()*1 )
	end
	if ( hitgroup == HITGROUP_STOMACH ) then
		dmginfo:ScaleDamage( 1 )
		dmginfo:SetDamageBonus( dmginfo:GetDamageBonus()*1.4 )
	end
	if ( hitgroup == HITGROUP_LEFTARM or  hitgroup == HITGROUP_RIGHTARM ) then
		dmginfo:ScaleDamage( 0.8 )
		dmginfo:SetDamageBonus( dmginfo:GetDamageBonus()*1.2 )
	end	
	if ( hitgroup == HITGROUP_LEFTLEG or  hitgroup == HITGROUP_RIGHTLEG ) then
		dmginfo:ScaleDamage( 0.8 )
		dmginfo:SetDamageBonus( dmginfo:GetDamageBonus()*1.3 )
	end
	
	ply:ApplyShock(dmginfo:GetDamageBonus())
	
	--Metal_Barrel.BulletImpact
	--Metal_Box.BulletImpact
	
	--ChainLink.BulletImpact
	
	--Flesh.BulletImpact
	
	--Wood_Plank.ImpactHard
	
	--weapon.BulletImpact
	
	
	
	--print(dmginfo:GetDamageBonus())
end