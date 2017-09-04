--瑞穗
function c18700315.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,18700315)
	e1:SetCost(c18700315.cost)
	e1:SetTarget(c18700315.target)
	e1:SetOperation(c18700315.operation)
	c:RegisterEffect(e1)
end
function c18700315.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18700315.filter(c)
	return c:IsFaceup() and c:IsDefensePos() and c:IsSetCard(0xab0)
end
function c18700315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsSetCard(0xab0) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c18700315.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18700315.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c18700315.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsDefensePos() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end