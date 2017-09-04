--梦锁灵珠
function c10981077.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10981077.target)
	e1:SetOperation(c10981077.activate)
	c:RegisterEffect(e1)	
end
function c10981077.filter(c)
	return c:IsAbleToHand() and not c:IsCode(10981077)
end
function c10981077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10981077.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10981077.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10981077.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10981077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and g:GetCount()>=20 and g:GetClassCount(Card.GetCode)==g:GetCount() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

