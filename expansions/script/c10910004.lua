--大霸星祭
function c10910004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10910004+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10910004.cost)
	e1:SetTarget(c10910004.target)
	e1:SetOperation(c10910004.activate)
	c:RegisterEffect(e1)	
end
function c10910004.dsfilter(c)
	return c:IsLevelBelow(5) and c:IsSetCard(0x23c) and c:IsDiscardable()
end
function c10910004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10910004.dsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c10910004.dsfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c10910004.filter(c,e,tp)
	return ((c:IsSetCard(0x23c) and c:IsLevelBelow(5)) or c:IsCode(5012601) or c:IsCode(5012622)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10910004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10910004.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10910004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10910004.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

