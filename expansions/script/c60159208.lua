--澄 万圣夜
function c60159208.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e1:SetValue(c60159208.xyzlimit)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e2)
	local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e3)
	--tograve
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60159208,1))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,60159208)
    e4:SetCondition(c60159208.tgcon)
    e4:SetTarget(c60159208.tgtg)
    e4:SetOperation(c60159208.tgop)
    c:RegisterEffect(e4)
	--search
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60159208,0))
    e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_HAND)
    e5:SetCost(c60159208.cost)
    e5:SetTarget(c60159208.target)
    e5:SetOperation(c60159208.operation)
    c:RegisterEffect(e5)
end
function c60159208.xyzlimit(e,c)
    if not c then return false end
    return not (c:IsSetCard(0x5b25) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION)))
end
function c60159208.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsReason(REASON_EFFECT)
end
function c60159208.filter(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60159208.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159208.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60159208.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159208.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c60159208.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c60159208.filter2(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function c60159208.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60159208.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60159208.filter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60159208.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60159208.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
    end
end
