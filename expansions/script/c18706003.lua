--GAIA
function c18706003.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),true)
	--POS
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c18706003.cost)
	e1:SetTarget(c18706003.target)
	e1:SetOperation(c18706003.operation)
	c:RegisterEffect(e1)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13959634,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c18706003.tg)
	e1:SetOperation(c18706003.op)
	c:RegisterEffect(e1)
end
function c18706003.thfilter(c)
    return c:IsSetCard(0xabb) and c:IsAbleToRemoveAsCost()
end
function c18706003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18706003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c18706003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c18706003.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsAbleToGrave() 
end
function c18706003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c18706003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SelectOption(tp,aux.Stringid(18706003,1))
	Duel.SelectOption(1-tp,aux.Stringid(18706003,1))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c18706003.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c18706003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c18706003.filter1(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function c18706003.filter2(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)
end
function c18706003.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706003.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	                        or Duel.IsExistingMatchingCard(c18706003.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c18706003.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SelectOption(tp,aux.Stringid(18706003,0))
	Duel.SelectOption(1-tp,aux.Stringid(18706003,0))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c18706003.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c18706003.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    if sg and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) then
	local ag=Duel.GetMatchingGroup(c18706003.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(ag,REASON_EFFECT)
	end
end