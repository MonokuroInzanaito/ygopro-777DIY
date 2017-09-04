--缲狼的终章
function c18755513.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18755513+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c18755513.target)
	e1:SetOperation(c18755513.activate)
	c:RegisterEffect(e1)
end
function c18755513.filter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsSetCard(0x5abb)
end
function c18755513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18755513.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) and not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
end
function c18755513.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18755513.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,2,nil)
	local ct=Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if ct>=1 then
		Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local vg1=Duel.SelectMatchingCard(tp,c18755513.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc1=vg1:GetFirst()
	if tc1 then
	Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if ct==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local vg2=Duel.SelectMatchingCard(tp,c18755513.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc2=vg2:GetFirst()
	if tc2 then
	Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	end
end
end
function c18755513.sfilter(c)
	return c:IsSetCard(0x5abb) and c:IsType(TYPE_PENDULUM)
end