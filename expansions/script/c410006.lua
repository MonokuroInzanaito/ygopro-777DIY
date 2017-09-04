--奈津惠
function c410006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c410006.splimit)
	c:RegisterEffect(e1) 
	--wudi
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(410006,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c410006.cost)
	e2:SetOperation(c410006.op)
	c:RegisterEffect(e2)	 
end
function c410006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c410006.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c410006.disop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetOperation(c410006.hdop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c410006.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c410006.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end
function c410006.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c410006.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local tg1=Group.CreateGroup()
	if (eg:IsExists(c410006.cfilter,1,nil,1-tp) and g1:GetCount()>=2) or (eg:IsExists(c410006.cfilter,1,nil,tp) and g2:GetCount()>=2) then
		Duel.Hint(HINT_CARD,0,410006)
	end
	if eg:IsExists(c410006.cfilter,1,nil,1-tp) and g1:GetCount()>=2 then
	   tg1:Merge(g1:RandomSelect(tp,2))
	end
	if eg:IsExists(c410006.cfilter,1,nil,tp) and g2:GetCount()>=2 then
	   tg1:Merge(g2:RandomSelect(tp,2))
	end
	if tg1:GetCount()>0 then
	   Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT)
	end
end
function c410006.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetActivateLocation()==LOCATION_HAND then 
	   Duel.NegateEffect(ev)
	end
end
function c410006.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end