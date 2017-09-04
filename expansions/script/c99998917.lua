--传说之剑士 弗兰肯斯坦
function c99998917.initial_effect(c)
	c:EnableCounterPermit(0xc)
	  --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT))
	c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99998917,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c99998917.con)
	e1:SetCost(c99998917.cost)
	e1:SetOperation(c99998917.op)
	c:RegisterEffect(e1)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c99998917.atkval)
	c:RegisterEffect(e3)
	--AddCounter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c99998917.cop1)
	c:RegisterEffect(e4)
	--Add counter2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c99998917.ccon)
	e5:SetOperation(c99998917.cop2)
	c:RegisterEffect(e5)
end
function c99998917.con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() 
end
function c99998917.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xc,1,REASON_COST)
end
function c99998917.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(e:GetHandler():GetAttack()*2)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			e:GetHandler():RegisterEffect(e1) 
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			e:GetHandler():RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(99998917,1))
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e3:SetCode(EVENT_BATTLED)
			e3:SetTarget(c99998917.target)
			e3:SetOperation(c99998917.operation)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			e:GetHandler():RegisterEffect(e3)	
end
function c99998917.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then
	   return (a==c and t~=nil) or (t==c) end
end
function c99998917.operation(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
   local g1,g2,g3
   if t==c then
   if a:GetSequence()-1>=0 then
	g3=a
   g1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,a:GetSequence()-1) 
end
	 if a:GetSequence()+1<5 then
   g2=Duel.GetFieldCard(1-tp,LOCATION_MZONE,a:GetSequence()+1)
end
end
 if a==c and t~=nil then
  g3=t
   if t:GetSequence()-1>=0 then
   g1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,t:GetSequence()-1) 
end
	 if t:GetSequence()+1<5 then
   g2=Duel.GetFieldCard(1-tp,LOCATION_MZONE,t:GetSequence()+1)
end
end
   if g1  then
   local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_CANNOT_ATTACK)
	  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	  g1:RegisterEffect(e1)
	 local e2=e1:Clone()
	 e2:SetCode(EFFECT_CANNOT_TRIGGER)
	 e2:SetValue(1)
	  g1:RegisterEffect(e2)
end
	if g2   then
   local e3=Effect.CreateEffect(e:GetHandler())
	  e3:SetType(EFFECT_TYPE_SINGLE)
	  e3:SetCode(EFFECT_CANNOT_ATTACK)
	  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	  g2:RegisterEffect(e3)
	 local e4=e3:Clone()
	 e4:SetCode(EFFECT_CANNOT_TRIGGER)
	 e4:SetValue(1)
	  g2:RegisterEffect(e4)
end
   if not g3:IsStatus(STATUS_BATTLE_DESTROYED) then
	 local e4=Effect.CreateEffect(e:GetHandler())
	  e4:SetType(EFFECT_TYPE_SINGLE)
	  e4:SetCode(EFFECT_CANNOT_ATTACK)
	  e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	  g3:RegisterEffect(e4)
	 local e5=e3:Clone()
	 e5:SetCode(EFFECT_CANNOT_TRIGGER)
	 e5:SetValue(1)
	  g3:RegisterEffect(e5)
end
end
function c99998917.atkval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0xc)*200
end
function c99998917.cop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)  then
		e:GetHandler():AddCounter(0xc,1)
	end
end
function c99998917.ccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
function c99998917.cop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xc,1)
end
