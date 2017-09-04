--战术人形编队
function c75010015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010015+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75010015.target)
	e1:SetOperation(c75010015.activate)
	c:RegisterEffect(e1)
end
function c75010015.filter(c)
	return c:IsSetCard(0x520) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c75010015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75010015.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c75010015.filter2(c)
	return c:IsCode(75010011) and c:IsAbleToHand()
end
function c75010015.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75010015.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local m=Duel.GetMatchingGroup(c75010015.filter2,tp,LOCATION_DECK,0,nil)
		if m:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75010015,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=m:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end