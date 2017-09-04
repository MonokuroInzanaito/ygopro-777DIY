--镜世录 红魔龙
function c29201065.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201065,5))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201065.pencon)
    e7:SetTarget(c29201065.pentg)
    e7:SetOperation(c29201065.penop)
    c:RegisterEffect(e7)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1,0)
    e12:SetCondition(c29201065.splimcon)
    e12:SetTarget(c29201065.splimit)
    c:RegisterEffect(e12)
    --spsummon
    local ea=Effect.CreateEffect(c)
    ea:SetDescription(aux.Stringid(29201065,0))
    ea:SetCategory(CATEGORY_SPECIAL_SUMMON)
    ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    ea:SetCode(EVENT_DESTROYED)
    ea:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    ea:SetRange(LOCATION_PZONE)
    ea:SetCountLimit(1)
    ea:SetCondition(c29201065.spcon)
    ea:SetCost(c29201065.spcost)
    ea:SetTarget(c29201065.sptg2)
    ea:SetOperation(c29201065.spop)
    c:RegisterEffect(ea)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201065,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,29201065)
    e2:SetTarget(c29201065.thtg)
    e2:SetOperation(c29201065.thop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end
function c29201065.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201065.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c29201065.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end 
end
function c29201065.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c29201065.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x63e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201065.thfilter(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x63e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201065.thfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29201065.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c29201065.thfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        local tc=sg:GetFirst()
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c29201065.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function c29201065.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201065.cfilter(c,tp)
    return c:IsSetCard(0x63e0) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c29201065.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201065.cfilter,1,nil,tp)
end
function c29201065.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(29201065)==0 end
    e:GetHandler():RegisterFlagEffect(29201065,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c29201065.filter(c,e,tp)
    return c:IsSetCard(0x63e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201065.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201065.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29201065.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201065.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

