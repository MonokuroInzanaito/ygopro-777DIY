--战场女武神 研究员
function c11113005.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11113005)
	e1:SetCost(c11113005.cost)
	e1:SetTarget(c11113005.target)
	e1:SetOperation(c11113005.operation)
	c:RegisterEffect(e1)
	--salvage 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1113005,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,11113005)
	e2:SetTarget(c11113005.thtg)
	e2:SetOperation(c11113005.thop)
	c:RegisterEffect(e2)
end	
function c11113005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c11113005.tfilter(c)
	return c:IsSetCard(0x15c) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function c11113005.rmfilter(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_MONSTER) and not c:IsCode(11113005) and c:IsAbleToRemove()
end
function c11113005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113005.tfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11113005.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c11113005.setcon)
	e1:SetOperation(c11113005.setop)
	Duel.RegisterEffect(e1,tp)
end
function c11113005.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11113005.tfilter,tp,LOCATION_DECK,0,1,nil)
end 
function c11113005.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,11113005)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11113005.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(c11113005.rmfilter,tp,LOCATION_GRAVE,0,nil)
	    if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11113005,2)) then
		    Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		    local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end	
	end
end	
function c11113005.thfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x15c) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function c11113005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c11113005.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11113005.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11113005.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11113005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end