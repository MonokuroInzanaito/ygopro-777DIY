--玲珑术-晶
function c21520078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520078,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21520078.actcon)
--	e1:SetTarget(c21520078.target)
	e1:SetOperation(c21520078.activate)
	c:RegisterEffect(e1)
	--INDESTRUCTABLE_BATTLE
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c21520078.filter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c21520078.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21520078.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and c:IsType(TYPE_MONSTER)
end
function c21520078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520078.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520078.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520078.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(21520078,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end
function c21520078.filter(e,c)
	return c:IsSetCard(0x495) and c:IsFaceup()
end
