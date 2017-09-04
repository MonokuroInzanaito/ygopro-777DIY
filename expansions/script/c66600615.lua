--6th-球型监狱
function c66600615.initial_effect(c)
	--tohand
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c66600615.activate)
	c:RegisterEffect(e1)
  --decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x66e))
	e2:SetValue(0x2)
	c:RegisterEffect(e2)
end
function c66600615.filter(c)
	return c:GetLevel()==3 and c:IsSetCard(0x66e) and c:IsAbleToHand()
end
function c66600615.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c66600615.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(66600615,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(66600615,1)) then
		Duel.ConfirmCards(1-tp,sg)
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	   else
	   Duel.ConfirmCards(1-tp,sg)
	end
end
end