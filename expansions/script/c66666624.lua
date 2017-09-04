--光与暗交织的星辉
function c66666624.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666624,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,66666624)
	e1:SetCondition(c66666624.condition)
	e1:SetTarget(c66666624.target)
	e1:SetOperation(c66666624.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666624,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,66666624)
	e2:SetCost(c66666624.cost)
	e2:SetCondition(c66666624.condition2)
	e2:SetTarget(c66666624.target2)
	e2:SetOperation(c66666624.activate2)
	c:RegisterEffect(e2)
end
function c66666624.filter1(c)
	return c:IsFaceup() and c:IsCode(66666611)
end
function c66666624.filter2(c)
	return c:IsFaceup() and (c:IsCode(66666610) or c:IsCode(66666612))
end
function c66666624.condition(e,tp)
	return Duel.IsExistingMatchingCard(c66666624.filter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c66666624.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66666624.filter(c)
	return c:IsSetCard(0x662) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c66666624.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666624.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c66666624.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66666624.filter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66666624.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66666624.condition2(e,tp)
	return Duel.IsExistingMatchingCard(c66666624.filter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c66666624.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66666624.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666624.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c66666624.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66666624.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end