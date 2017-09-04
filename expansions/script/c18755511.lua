--少女的团结
function c18755511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18755511+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c18755511.drcost)
	e1:SetTarget(c18755511.target)
	e1:SetOperation(c18755511.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(18755511,ACTIVITY_SPSUMMON,c18755511.counterfilter)
end
function c18755511.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xabb)
end
function c18755511.counterfilter(c)
	return c:IsSetCard(0xabb)
end
function c18755511.cfilter(c)
	return c:IsSetCard(0x5abb) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function c18755511.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18755511.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.GetCustomActivityCount(18755511,tp,ACTIVITY_SPSUMMON)==0 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c18755511.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c18755511.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c18755511.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c18755511.filter(c,e,tp)
	return c:IsSetCard(0x5abb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18755511.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c18755511.filter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c18755511.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c18755511.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:RandomSelect(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g:RandomSelect(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
