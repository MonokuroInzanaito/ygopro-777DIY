--镜世录 超妖怪弹头
function c29201017.initial_effect(c)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201017,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCost(c29201017.spcost)
    e2:SetTarget(c29201017.target)
    e2:SetOperation(c29201017.operation)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201017,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,29201017)
    e3:SetCondition(c29201017.spcon1)
    e3:SetTarget(c29201017.sptg1)
    e3:SetOperation(c29201017.spop1)
    c:RegisterEffect(e3)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201017,2))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201017.pencon)
    e7:SetTarget(c29201017.pentg)
    e7:SetOperation(c29201017.penop)
    c:RegisterEffect(e7)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201017.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_SZONE)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201017.splimit)
    c:RegisterEffect(e13)
end
function c29201017.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201017.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201017.penop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
end
function c29201017.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c29201017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201017.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201017.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c29201017.filter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0x63e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c29201017.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c29201017.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c29201017.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c29201017.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
function c29201017.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201017.cfilter1(c,tp)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c29201017.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201017.cfilter1,1,nil,tp)
end
function c29201017.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201017.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

