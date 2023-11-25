
Ballistics={}
Ballistics.Bullets={}
Bullet={}

Ballistics.BulletMask = CONTENTS_SOLID + CONTENTS_MONSTER + CONTENTS_HITBOX + CONTENTS_DEBRIS + CONTENTS_GRATE
Ballistics.BreakableSurfaces = {}

Ballistics_AmmoProps={
	["Pistol"]={
		Drag=70,			--Часть скорости потерянная за тик. (Больше == меньше потерянной скорости) (Баллистичность пули)
		EffectiveVel=65, 	--Эффективная скорость поражения. Если скорость падает меньше этого значения, то урон значительно уменьшается
		Drift=0.1,			--Сила смещения позиции пули в полёте, у дробовиковой картечи она должна быть высокой потомучто да и потомучто так она хотябы попадает по противнику (Это максимум в юнитах)
		EffectSize=7,		--Размер эффекта брызг воды(или поломки стекла) при попадании по воде или стеклу крутому
		DmgType=DMG_BULLET
	},--etc
	["Buckshot"]={
		Drag=20,
		EffectiveVel=95,
		Drift=2,
		EffectSize=5,
		DmgType=DMG_BULLET
	},
}

function Ballistics:FireBullets(bullets)
	for i=1,bullets.Num do
		local bullet = {}
		bullet.Pos		= bullets.Src
		bullet.Dir		= (bullets.Dir+bullets.Spread*VectorRand()):GetNormalized()
		bullet.Vel		= bullets.Vel or 400
		--((V*40.4)/66)					-- Эта формула перевода из метров в секунду в юниты в тик. Первое число-ожидаемая скорость в м/с. Можно заменить 66 на 1/engine.TickInterval()
		bullet.Damage	= bullets.Damage
		bullet.Inflictor= bullets.Inflictor
		bullet.Attacker	= bullets.Attacker
		bullet.AmmoType	= bullets.AmmoType
		bullet.UnderWater = bullets.UnderWater or false
		bullet.CreationTime	= bullets.CreationTime or CurTime()
		
		bullet.Hit 		= bullets.Hit	--Т.к. строками выше мы пересоздаём таблицу, то... требуется так делать ради функций
		bullet.Update 	= bullets.Update
		
		bullet.AmmoInfo	= Ballistics:GetAmmoInfo(bullet.AmmoType)
		self:RegisterBullet(bullet)
	end
end

function Ballistics:GetAmmoInfo(Ammo)
	if(isnumber(Ammo))then
		Ammo = game.GetAmmoName(Ammo)
		return Ballistics_AmmoProps[Ammo]
	else
		return Ballistics_AmmoProps[Ammo]
	end
end

function Ballistics:RegisterBullet(bullet)
	bull = Bullet:new(bullet)
	table.insert(Ballistics.Bullets,bull)
	return bull
end

function Ballistics:KillAllBullets()
	for i,bull in pairs(Ballistics.Bullets)do
		bull:Remove(i)
	end
	Ballistics.BreakableSurfaces={}
end

function Bullet:new(bullet)
	function bullet:Remove(Key)
		Ballistics.Bullets[Key]=nil
		table.Empty(bullet)
		bullet=nil
	end
	
	bullet.Update = bullet.Update or function(self,Key)
		if(CurTime()-self.CreationTime>=7)then
			--print(Key .." Removed because of life time") 
			self:Remove(Key)
			return
		end
		local expectedDamage = math.Clamp(self.Vel,0,self.AmmoInfo.EffectiveVel)/self.AmmoInfo.EffectiveVel
		local position = self.Pos
		self.Vel=math.Clamp(self.Vel-self.Vel/self.AmmoInfo.Drag,0,math.huge)
		local waterSuppression=1
		if(self.UnderWater)then
			waterSuppression=10
		end
		local expectedPos=position+self.Dir*self.Vel-( math.Clamp((1-expectedDamage),0.05,math.huge)*Vector(0,0,12-waterSuppression) )+VectorRand()*math.Clamp(self.AmmoInfo.Drift*waterSuppression,0,10)
		
		local expectedMask = Ballistics.BulletMask + MASK_WATER + CONTENTS_WINDOW
		if(self.UnderWater)then
			expectedMask = Ballistics.BulletMask + CONTENTS_WINDOW
		end
		
		effects.BeamRingPoint(self.Pos, 0.2, 12, 64, 12, 0, Color(255,255,225,32),{
			speed=0,
			spread=0,
			delay=0,
			framerate=2,
			material="sprites/lgtning.vmt"
		})
		
		local tracetable={
			start = position,
			endpos = expectedPos,
			filter = self.Attacker,
			mask = expectedMask,
		}
		local trace=util.TraceLine(tracetable)
		local hitClass
		if(IsValid(trace.Entity))then
			hitClass = trace.Entity:GetClass()
		end

		if(trace.Hit)then
			
			if(hitClass!="ent_glasstrigger" and trace.Contents==CONTENTS_GRATE)then
			
				local tracetable={
					start = position,
					endpos = expectedPos,
					filter = self.Attacker,
					mask = Ballistics.BulletMask - CONTENTS_GRATE
				}
				trace=util.TraceLine(tracetable)
				if(trace.Hit)then
					self:Hit(Key,trace,expectedDamage)
				end			
				
			elseif(hitClass=="func_breakable_surf" or hitClass=="ent_glasstrigger")then															--штука для перевода 3д координат на plane в x y(спермоид)
				
				local alreadyHas = false
				local target = trace.Entity
				if(hitClass=="ent_glasstrigger")then
					alreadyHas=true
					target=trace.Entity.GlassPanel
				end
				
				local upperright = target:GetInternalVariable("upperright")
				local lowerleft = target:GetInternalVariable("lowerleft")
				local upperleft = target:GetInternalVariable("upperleft")
				
				local shatterPos = Ballistics:TranslateVectorToBPlane(upperright,lowerleft,upperleft,trace.HitPos)
				
				local xPos = shatterPos[1]
				local yPos = shatterPos[2]
				
				target:Fire("Shatter",xPos.." "..yPos.." "..10)
				if(!alreadyHas and !Ballistics.BreakableSurfaces[target])then
					local glasstrigger = ents.Create("ent_glasstrigger")
					glasstrigger.GlassPanel = target
					glasstrigger:Spawn()
					glasstrigger:Activate()
				end
				Ballistics.BreakableSurfaces[target]=true
				
				local tracetable={
					start = position,
					endpos = expectedPos,
					filter = self.Attacker,
					mask = Ballistics.BulletMask - CONTENTS_GRATE
				}
				trace=util.TraceLine(tracetable)
				if(trace.Hit)then
					self:Hit(Key,trace,expectedDamage)
				end
				
			elseif(trace.SurfaceProps==22)then		--22 is water
			
				local effect = EffectData()
				effect:SetOrigin( trace.HitPos )
				effect:SetNormal( trace.HitNormal )
				effect:SetScale( self.AmmoInfo.EffectSize*expectedDamage )
				util.Effect( "watersplash", effect )
				self.Vel=math.Clamp(self.Vel-(self.Vel/self.AmmoInfo.Drag)*20,0,math.huge)
				self.UnderWater=true
				local tracetable={
					start = position,
					endpos = expectedPos,
					filter = self.Attacker,
					mask = Ballistics.BulletMask + CONTENTS_WINDOW
				}
				trace=util.TraceLine(tracetable)
				if(trace.Hit)then
					self:Hit(Key,trace,expectedDamage)
				end	
				
			elseif(trace.SurfaceProps==0)then	--0 is everything inside
			
				self.Vel=math.Clamp(self.Vel-(self.Vel/self.AmmoInfo.Drag)*40,0,math.huge)
				self.UnderWater=true
				local tracetable={
					start = position,
					endpos = expectedPos,
					filter = self.Attacker,
					mask = Ballistics.BulletMask + CONTENTS_WINDOW
				}
				trace=util.TraceLine(tracetable)
				if(trace.Hit)then
					self:Hit(Key,trace,expectedDamage)
				else
					local tracetable={
						start = expectedPos,
						endpos = position,
						filter = self.Attacker,
						mask = MASK_WATER
					}
					trace=util.TraceLine(tracetable)
					if(trace.SurfaceProps==22)then
						self.UnderWater=false
					end
				end
				
			else
			
				self.UnderWater=false
				self:Hit(Key,trace,expectedDamage)
				return
				
			end
			
		elseif(self.UnderWater)then
			self.Vel=math.Clamp(self.Vel-(self.Vel/self.AmmoInfo.Drag)*10,0,math.huge)
		end

		--self:TryHitGShards(expectedPos,expectedDamage)

		self.Pos=expectedPos
	end	
--[[
	function bullet:TryHitGShards(expectedPos,expectedDamage)
		for surf, _ in pairs(Ballistics.BreakableSurfaces)do
			local upperleft = surf:GetInternalVariable("upperleft")
			local upperright = surf:GetInternalVariable("upperright")
			local lowerleft = surf:GetInternalVariable("lowerleft")
			local normal = (upperleft-lowerleft):GetNormalized()
			local intersectPos = util.IntersectRayWithPlane(self.Pos,(expectedPos-self.Pos):GetNormalized(),upperleft,Vector(1,0,0))

			if( intersectPos!=nil and self.Pos:DistToSqr(intersectPos)<190000 )then
				local shatterPos = Ballistics:TranslateVectorToBPlane(upperright,lowerleft,upperleft,intersectPos)
				local xPos = shatterPos[1]
				local yPos = shatterPos[2]
				surf:Fire("Shatter",xPos.." "..yPos.." "..self.AmmoInfo.EffectSize*expectedDamage*2)				
			end
		end	
	end
]]
	bullet.Hit = bullet.Hit or function(self,Key,TraceData,ExpectedDamage)
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage( self.Damage*ExpectedDamage )
		dmgInfo:SetDamageType( self.AmmoInfo.DmgType )
		dmgInfo:SetDamagePosition( TraceData.HitPos )
		dmgInfo:SetAttacker( self.Attacker )
		dmgInfo:SetInflictor( self.Inflictor or Entity(0) )
		dmgInfo:SetDamageForce( self.Dir*self.Vel )
		TraceData.Entity:TakeDamageInfo( dmgInfo )	--Можно тут сурсовской пулькой стрелять впринципе..
		--print(Key .." Removed because of hit")
		--print("Damaged "..dmgInfo:GetDamage().." With velocity of "..self.Vel)
		--print("Bullet hit at "..SysTime())
		--print(TraceData.HitPos)
		Ballistics:RicochetOrPenetrate(TraceData,self)
		self:Remove(Key)
	end

	setmetatable(bullet,self)
	return bullet
end


hook.Add("Think","Bullet_Update",function()			--Можно добавить таким же образом хук для рендера, если нужен..(как можно увидеть нетрассированную пулю???)
	for i,bull in pairs(Ballistics.Bullets)do
		bull:Update(i)
	end
end)

hook.Add("PostCleanupMap","Ballistics",function()
	Ballistics:KillAllBullets()
	Ballistics.BreakableSurfaces={}
	for key, ent in pairs(ents.FindByClass("func_breakable_surf"))do
		local glasstrigger = ents.Create("ent_glasstrigger")
		glasstrigger.GlassPanel = ent
		glasstrigger:Spawn()
		glasstrigger:Activate()
		Ballistics.BreakableSurfaces[ent]=true
	end
end)

hook.Add("PostGamemodeLoaded","Ballistics",function()
	for key, ent in pairs(ents.FindByClass("func_breakable_surf"))do
		local glasstrigger = ents.Create("ent_glasstrigger")
		glasstrigger.GlassPanel = ent
		glasstrigger:Spawn()
		glasstrigger:Activate()
		Ballistics.BreakableSurfaces[ent]=true
	end
end)

hook.Add("ShouldCollide","Ballistics",function(Ent,Ent1)
	if(Ent:GetClass()=="ent_glasstrigger" or Ent1:GetClass()=="ent_glasstrigger")then 
		return false
	end
end)

function Ballistics:TranslateVectorToBPlane(upperright,lowerleft,upperleft,HitPos)
	
	local vectorDifference = lowerleft - upperright
	vectorDifference = Vector(1/math.abs(vectorDifference[1]),1/math.abs(vectorDifference[2]),1/math.abs(vectorDifference[3]))
	local shatterPos
	shatterPos = WorldToLocal(HitPos,Angle(0,0,0),upperleft,Angle(0,0,0))
	local shatterDifference = shatterPos*vectorDifference
	shatterDifference = Vector(math.abs(shatterDifference[1]),math.abs(shatterDifference[2]),math.abs(shatterDifference[3]))
	
	local xPos	=	shatterDifference[1]
	local yPos	=	shatterDifference[3]

	if(tostring(xPos)=="nan" or xPos==math.huge)then		--ненужные позиции по какой-то причине становятся бесконечностью, а это удобно!
		xPos=shatterDifference[2]
	end
	
	return Vector(xPos,yPos,0)
end

--Jackarunda's code
function Ballistics:RicochetOrPenetrate(initialTrace,Bullet)
	local AVec,IPos,TNorm,SMul=initialTrace.Normal,initialTrace.HitPos,initialTrace.HitNormal,HMCD_SurfaceHardness[initialTrace.MatType]
	if not(SMul)then SMul=.5 end
	local ApproachAngle=-math.deg(math.asin(TNorm:DotProduct(AVec)))
	local MaxRicAngle=60*SMul
	if(ApproachAngle>(MaxRicAngle*1.25))then -- all the way through
		local MaxDist,SearchPos,SearchDist,Penetrated=(Bullet.Damage/SMul)*.15,IPos,5,false
		while((not(Penetrated))and(SearchDist<MaxDist))do
			SearchPos=IPos+AVec*SearchDist
			local PeneTrace=util.QuickTrace(SearchPos,-AVec*SearchDist)
			if((not(PeneTrace.StartSolid))and(PeneTrace.Hit))then
				Penetrated=true
			else
				SearchDist=SearchDist+5
			end
		end
		if(Penetrated)then
			Ballistics:FireBullets({
				Attacker=Bullet.Attacker,
				Inflictor=Bullet.Inflictor,
				AmmoType=Bullet.AmmoType,
				Damage=Bullet.Damage*.65,
				Force=Bullet.Damage/15,
				Vel		= Bullet.Vel*0.4,
				UnderWater = Bullet.UnderWater,
				CreationTime = Bullet.CreationTime,
				Num=1,
				Tracer=0,
				TracerName="",
				Dir=AVec,
				Spread=Vector(0,0,0),
				Src=SearchPos+AVec
			})
			local effect=EffectData()
			effect:SetEntity(initialTrace.Entity)
			effect:SetOrigin(IPos)
			effect:SetStart(Bullet.Pos)
			effect:SetSurfaceProp(initialTrace.SurfaceProps)
			effect:SetDamageType(Bullet.AmmoInfo.DmgType)
			effect:SetHitBox(initialTrace.HitBox)
			util.Effect("Impact",effect,true)
			local effect=EffectData()
			effect:SetEntity(initialTrace.Entity)
			effect:SetOrigin(SearchPos+AVec)
			effect:SetStart(IPos)
			effect:SetSurfaceProp(initialTrace.SurfaceProps)
			effect:SetDamageType(Bullet.AmmoInfo.DmgType)
			effect:SetHitBox(initialTrace.HitBox)
			util.Effect("Impact",effect,true)
			return false
		end
	elseif(ApproachAngle<(MaxRicAngle*.75))then -- ping whiiiizzzz
		sound.Play("snd_jack_hmcd_ricochet_"..math.random(1,2)..".wav",IPos,70,math.random(90,100))
		local NewVec=AVec:Angle()
		NewVec:RotateAroundAxis(TNorm,180)
		local AngDiffNormal=math.deg(math.acos(NewVec:Forward():Dot(TNorm)))-90
		NewVec:RotateAroundAxis(NewVec:Right(),AngDiffNormal*.7) -- bullets actually don't ricochet elastically
		NewVec=NewVec:Forward()
		Ballistics:FireBullets({
			Attacker=Bullet.Attacker,
			Inflictor=Bullet.Inflictor,
			AmmoType=Bullet.AmmoType,
			Damage=Bullet.Damage*.5,
			Force=Bullet.Damage/15,
			Vel		= Bullet.Vel*0.2,
			UnderWater = Bullet.UnderWater,
			CreationTime = Bullet.CreationTime,
			Num=1,
			Tracer=0,
			TracerName="",
			Dir=-NewVec,
			Spread=Vector(0,0,0),
			Src=IPos+TNorm
		})
		local effect=EffectData()
		effect:SetEntity(initialTrace.Entity)
		effect:SetOrigin(IPos)
		effect:SetStart(Bullet.Pos)
		effect:SetSurfaceProp(initialTrace.SurfaceProps)
		effect:SetDamageType(Bullet.AmmoInfo.DmgType)
		effect:SetHitBox(initialTrace.HitBox)
		util.Effect("Impact",effect,true)
		return false
	end
	local effect=EffectData()
	effect:SetEntity(initialTrace.Entity)
	effect:SetOrigin(IPos)
	effect:SetStart(Bullet.Pos)
	effect:SetSurfaceProp(initialTrace.SurfaceProps)
	effect:SetDamageType(Bullet.AmmoInfo.DmgType)
	effect:SetHitBox(initialTrace.HitBox)
	util.Effect("Impact",effect,true)
	return true
end