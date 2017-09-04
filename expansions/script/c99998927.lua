--日轮之城
function c99998927.initial_effect(c)
	c:EnableCounterPermit(0x2b) 
	aux.AddRitualProcGreaterCode(c,99998926) 
	--remain field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	 --counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c99998927.ctcon)
	e2:SetOperation(c99998927.ctop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(99998927)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c99998927.cost)
	e3:SetTarget(c99998927.tg)
	e3:SetOperation(c99998927.op)
	c:RegisterEffect(e3)
	--atk/def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c99998927.atkup)
	e4:SetValue(c99998927.val)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetTarget(c99998927.atkdw)
	e6:SetValue(c99998927.val2)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	e7:SetTarget(c99998927.atkdw)
	e7:SetValue(c99998927.val2)
	c:RegisterEffect(e7)
end
function c99998927.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY)
end
function c99998927.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99998927.cfilter,1,nil)
end
function c99998927.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c99998927.cfilter,nil)
	e:GetHandler():AddCounter(0x2b,ct)
   if e:GetHandler():GetCounter(0x2b)>=7 then
  Duel.RaiseSingleEvent(e:GetHandler(),99998927,e,0,tp,0,0)
end
end
function c99998927.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c99998927.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
   local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,g:GetCount()*500)
end
function c99998927.op(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
 if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
	  local val=Duel.GetOperatedGroup():GetCount()
	  Duel.Damage(tp,val*500,REASON_EFFECT)
	  Duel.Damage(1-tp,val*500,REASON_EFFECT)
end
end
function c99998927.atkup(e,c)
	return c:IsCode(99998926) and c:IsFaceup()
end
function c99998927.atkdw(e,c)
	return not c:IsCode(99998926) and c:IsFaceup()
end
function c99998927.val(e,c)
	return e:GetHandler():GetCounter(0x2b)*300
end
function c99998927.val2(e,c)
	return -e:GetHandler():GetCounter(0x2b)*300
end