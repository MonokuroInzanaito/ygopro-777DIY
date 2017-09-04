--聖女小準
function c18799004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95027497,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,18799004)
	e1:SetTarget(c18799004.thtg)
	e1:SetOperation(c18799004.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23874409,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1879904)
	e2:SetCondition(c18799004.spcon)
	e2:SetTarget(c18799004.tg)
	e2:SetOperation(c18799004.op)
	c:RegisterEffect(e2)
end
function c18799004.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xab0) and c:IsType(TYPE_MONSTER)
end
function c18799004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,18799004)==0 and Duel.IsExistingMatchingCard(c18799004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,18799004,RESET_PHASE+PHASE_END,0,1)
end
function c18799004.thop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18799004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18799004.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c18799004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(18799010,tp)
end
function c18799004.afilter(c)
	return c:IsAbleToDeck()
end
function c18799004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c18799004.afilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18799004.afilter,tp,0,LOCATION_SZONE,1,nil) and Duel.IsEnvironment(18799010) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c18799004.afilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c18799004.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end