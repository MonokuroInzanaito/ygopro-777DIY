--红色骑士团·业果
function c60158804.initial_effect(c)
	--to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60158804,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,60158804)
    e1:SetCost(c60158804.cost)
    e1:SetTarget(c60158804.target)
    e1:SetOperation(c60158804.operation)
    c:RegisterEffect(e1)
	--spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158804,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,6018804)
    e2:SetCondition(c60158804.spcon)
    e2:SetTarget(c60158804.sptg)
    e2:SetOperation(c60158804.spop)
    c:RegisterEffect(e2)
end
function c60158804.cfilter(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c60158804.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158804.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c60158804.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c60158804.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c60158804.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60158804.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c60158804.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c60158804.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        if Duel.SelectOption(tp,aux.Stringid(60158804,1),aux.Stringid(60158804,2))==0 then
            Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
        else
            Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
        end
    end
end
function c60158804.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
end
function c60158804.spfilter(c,e,tp)
    return c:IsSetCard(0x5b28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158804.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60158804.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60158804.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60158804.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end