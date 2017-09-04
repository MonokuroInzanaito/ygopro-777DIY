--镜世录 龙宫的使者
function c29201044.initial_effect(c)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201044,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c29201044.spcon)
    e1:SetTarget(c29201044.sptg)
    e1:SetOperation(c29201044.spop)
    c:RegisterEffect(e1)
    --place
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201044,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(c29201044.target)
    e2:SetOperation(c29201044.operation)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201044,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,29201044)
    e3:SetCondition(c29201044.spcon5)
    e3:SetTarget(c29201044.sptg5)
    e3:SetOperation(c29201044.spop5)
    c:RegisterEffect(e3)
    --race
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCode(EFFECT_CHANGE_RACE)
    e4:SetValue(RACE_AQUA)
    c:RegisterEffect(e4)  
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201044.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_SZONE)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201044.splimit)
    c:RegisterEffect(e13)
end
function c29201044.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201044.setfilter(c)
    return c:IsSetCard(0x63e0) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) 
end
function c29201044.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c29201044.setfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c29201044.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectTarget(tp,c29201044.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c29201044.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(tc)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c29201044.splimit1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c29201044.splimit1(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201044.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and eg:GetFirst():IsSetCard(0x63e0)
end
function c29201044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201044.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
        local atk=c:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(atk/2)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1,true)
        Duel.SpecialSummonComplete()
    elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c29201044.spcon5(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c29201044.spfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
end
function c29201044.sptg5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c29201044.spfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c29201044.spop5(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local g=Duel.SelectMatchingCard(tp,c29201044.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
end
