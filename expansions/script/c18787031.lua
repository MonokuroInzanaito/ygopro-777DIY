--少女们的宴会
function c18787031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,18787031)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18787031.target)
	e1:SetOperation(c18787031.activate)
	c:RegisterEffect(e1)
end
function c18787031.filter(c)
	local atk=c:GetAttack()
	return atk>=0 and atk<=1000 and c:IsSetCard(0xabb) and c:IsAbleToHand() and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c18787031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c18787031.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18787031.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c18787031.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c18787031.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end