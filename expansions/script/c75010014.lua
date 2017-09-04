--战术人形镇压
function c75010014.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010014+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c75010014.cost)
	e1:SetTarget(c75010014.target)
	e1:SetOperation(c75010014.activate)
	c:RegisterEffect(e1)
end
function c75010014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75010014.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c75010014.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c75010014.tdfilter(c)
	return c:IsCode(75010011) and c:IsAbleToDeckAsCost()
end
function c75010014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetSummonLocation()==LOCATION_EXTRA and chkc:IsReleasable() end
	if chk==0 then return Duel.IsExistingTarget(c75010014.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c75010014.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c75010014.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c75010014.filter(c)
	return c:IsReleasable()
end
function c75010014.filter2(c,e,tp)
	return c:IsSetCard(0x520) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c75010014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Release(tc,REASON_EFFECT)~=0 then
			local sc=Duel.SelectMatchingCard(tp,c75010014.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end