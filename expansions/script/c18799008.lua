--妙子
function c18799008.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17393207,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18799008)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c18799008.cost)
	e1:SetTarget(c18799008.target)
	e1:SetOperation(c18799008.operation)
	c:RegisterEffect(e1)
   --indes
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(83994433,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,1879908)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c18799008.costa)
    e1:SetTarget(c18799008.sptg)
    e1:SetOperation(c18799008.spop)
    c:RegisterEffect(e1)
end
function c18799008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c18799008.costa(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c18799008.filter(c)
	return c:GetCode()==18799010 and c:IsAbleToHand()
end
function c18799008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18799008.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18799008.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18799008.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18799008.afilter(c)
	return c:IsFacedown() and c:IsSetCard(0xab0) and c:IsType(TYPE_MONSTER)
end
function c18799008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c18799008.afilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c18799008.afilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c18799008.afilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18799008.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFacedown() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCountLimit(1)
        e1:SetValue(c18799008.valcon)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c18799008.valcon(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
