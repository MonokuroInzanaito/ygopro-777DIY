--凋叶棕-悠久的摇篮曲
function c29200124.initial_effect(c)
    --[[counter
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200124,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CUSTOM+29200001)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,29200124)
    e2:SetTarget(c29200124.sptg)
    e2:SetOperation(c29200124.spop)
    c:RegisterEffect(e2)]]
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1e0)
    e1:SetTarget(c29200124.target)
    e1:SetOperation(c29200124.activate)
    c:RegisterEffect(e1)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200124,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,29200124)
    e3:SetCost(c29200124.spcost)
    e3:SetTarget(c29200124.sptg)
    e3:SetOperation(c29200124.spop)
    c:RegisterEffect(e3)
end
function c29200124.cfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c29200124.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200124.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
        and e:GetHandler():GetFlagEffect(29200124)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c29200124.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:GetHandler():RegisterFlagEffect(29200124,RESET_CHAIN,0,1)
end
function c29200124.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,29200124,0x53e0,0x11,3,1600,1400,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29200124.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,29200124,0x53e0,0x11,3,1600,1400,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
        c:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_DARK,RACE_SPELLCASTER,3,1600,1400)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
        e1:SetReset(RESET_EVENT+0x47c0000)
        c:RegisterEffect(e1,true)
        --redirect
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+0x47e0000)
        e2:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e2,true)
        local e10=Effect.CreateEffect(e:GetHandler())
        e10:SetType(EFFECT_TYPE_SINGLE)
        e10:SetCode(EFFECT_SET_BASE_ATTACK)
        e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e10:SetValue(1600)
        --e10:SetReset(RESET_EVENT+0x1fe0000)
        e10:SetReset(RESET_EVENT+0x47c0000)
        c:RegisterEffect(e10)
        local e12=e10:Clone()
        e12:SetCode(EFFECT_SET_BASE_DEFENSE)
        e12:SetValue(1400)
        c:RegisterEffect(e12)
        local e3=e10:Clone()
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(3)
        c:RegisterEffect(e3)
        local e4=e10:Clone()
        e4:SetCode(EFFECT_CHANGE_RACE)
        e4:SetValue(RACE_SPELLCASTER)
        c:RegisterEffect(e4)
        local e5=e10:Clone()
        e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e5:SetValue(ATTRIBUTE_DARK)
        c:RegisterEffect(e5)
        local e6=e1:Clone()
        e6:SetCode(EFFECT_CHANGE_TYPE)
        e6:SetValue(0x11)
        c:RegisterEffect(e6)
        Duel.SpecialSummonComplete()
    end
end
function c29200124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29200124.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
