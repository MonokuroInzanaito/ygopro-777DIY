--王之财宝
function c99998972.initial_effect(c)  
    --Activate  
    local e1=Effect.CreateEffect(c)  
    e1:SetType(EFFECT_TYPE_ACTIVATE)  
    e1:SetCode(EVENT_FREE_CHAIN)  
    e1:SetCondition(c99998972.actcon)
	e1:SetOperation(c99998972.actop)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c99998972.descon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99991099,7))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1,99998972+EFFECT_COUNT_CODE_OATH)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0+TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c99998972.target)
	e3:SetOperation(c99998972.operation)
	c:RegisterEffect(e3)
end
function c99998972.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2e3)
end
function c99998972.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998972.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99998972.descon(e)
	return not Duel.IsExistingMatchingCard(c99998972.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end
function c99998972.sefilter(c,ft)
	return c:IsType(TYPE_EQUIP) and (c:IsAbleToHand() or (Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,1,nil) and ft>0))
end
function c99998972.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998972.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ft) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99998972.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local tc=Duel.SelectMatchingCard(tp,c99998972.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ft)
	if tc then
	if ft>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and (not tc:GetFirst():IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Equip(tp,tc:GetFirst(),g:GetFirst())
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
end