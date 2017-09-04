--中华少女·纯白
function c60158707.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,nil,8,2)
    c:EnableReviveLimit()
	--
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60158707,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,60158707)
    e1:SetCost(c60158707.spcost)
    e1:SetTarget(c60158707.sptg)
    e1:SetOperation(c60158707.spop)
    c:RegisterEffect(e1)
	--indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c60158707.imtg)
    e2:SetValue(aux.tgoval)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
	--activate cost
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c60158707.actarget)
    e4:SetCost(c60158707.costchk)
    e4:SetOperation(c60158707.costop)
    c:RegisterEffect(e4)
	--negate
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60158707,1))
    e5:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c60158707.discon)
    e5:SetCost(c60158707.discost)
    e5:SetTarget(c60158707.distg)
    e5:SetOperation(c60158707.disop)
    c:RegisterEffect(e5)
end
function c60158707.cfilter(c)
    return c:IsSetCard(0x6b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c60158707.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158707.cfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60158707.cfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c60158707.filter(c,e,tp,ft)
    return c:IsSetCard(0x6b28) and c:IsType(TYPE_MONSTER) 
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c60158707.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingTarget(c60158707.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c60158707.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND,g,1,0,0)
end
function c60158707.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(60158707,2))) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end
function c60158707.imtg(e,c)
    return c:IsSetCard(0x6b28)
end
function c60158707.actarget(e,te,tp)
    return te:GetHandler():IsType(TYPE_MONSTER) and te:GetHandler():IsSetCard(0x6b28)
end
function c60158707.costchk(e,te_or_c,tp)
    return true
end
function c60158707.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,60158707,RESET_CHAIN,0,1)
end
function c60158707.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp
		and Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(tp,60158707)>0
end
function c60158707.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60158707.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function c60158707.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
    end
end
