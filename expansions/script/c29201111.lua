--天辉团-光言灵师 克莱儿
function c29201111.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201111.reptg)
    ea:SetValue(c29201111.repval)
    ea:SetOperation(c29201111.repop)
    c:RegisterEffect(ea)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c29201111.splimit)
    c:RegisterEffect(e2)
    --attack all
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201111,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCondition(c29201111.condition)
    e3:SetTarget(c29201111.target)
    e3:SetOperation(c29201111.operation)
    c:RegisterEffect(e3)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201111,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,29201103)
    e1:SetTarget(c29201111.sumtg)
    e1:SetOperation(c29201111.sumop)
    c:RegisterEffect(e1)
    local e4=e1:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --special summon
    local e15=Effect.CreateEffect(c)
    e15:SetDescription(aux.Stringid(29201111,0))
    e15:SetType(EFFECT_TYPE_FIELD)
    e15:SetCode(EFFECT_SPSUMMON_PROC)
    e15:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e15:SetRange(LOCATION_HAND)
    e15:SetCountLimit(1,29201105)
    e15:SetCondition(c29201111.spcon)
    e15:SetOperation(c29201111.spop)
    c:RegisterEffect(e15)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e15:SetCountLimit(1,29201111)
    e1:SetCondition(c29201111.spcon7)
    e1:SetTarget(c29201111.sptg7)
    e1:SetOperation(c29201111.spop7)
    c:RegisterEffect(e1)
end
function c29201111.spcon7(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsContains(e:GetHandler())
end
function c29201111.spfilter(c,e,tp)
    return  (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29201111.sptg7(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201111.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29201111.spop7(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201111.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c29201111.spfilter7(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and not c:IsCode(29201111) and c:IsAbleToHandAsCost()
end
function c29201111.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c29201111.spfilter7,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29201111.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201111.spfilter7,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c29201111.filter(c,e,tp)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201111.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201111.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29201111.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201111.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c29201111.splimit(e,c,sump,sumtype,sumpos,targetp)
    if c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1) then return false end
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201111.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201111.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201111.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201111,3))
end
function c29201111.repval(e,c)
    return c29201111.repfilter(c,e:GetHandlerPlayer())
end
function c29201111.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201111.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c29201111.filter7(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) 
end
function c29201111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29201111.filter7(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201111.filter7,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c29201111.filter7,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29201111.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(c29201111.atkfilter)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c29201111.atkfilter(e,c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end


