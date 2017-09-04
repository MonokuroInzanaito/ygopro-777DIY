--镜世录 茨华仙
function c29201026.initial_effect(c)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_HAND)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetTarget(c29201026.sptg)
    e5:SetOperation(c29201026.spop)
    c:RegisterEffect(e5)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201026,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c29201026.condition)
    e1:SetCost(c29201026.cost)
    e1:SetTarget(c29201026.target)
    e1:SetOperation(c29201026.operation)
    c:RegisterEffect(e1)
    --special summon
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201026,1))
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e10:SetCode(EVENT_TO_GRAVE)
    e10:SetCondition(c29201026.condtion5)
    e10:SetTarget(c29201026.target5)
    e10:SetOperation(c29201026.operation5)
    c:RegisterEffect(e10)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201026.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_ONFIELD)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201026.splimit)
    c:RegisterEffect(e13)
    --extra summon
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetRange(LOCATION_ONFIELD)
    e10:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e10:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e10:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x63e0))
    c:RegisterEffect(e10)
end
function c29201026.desfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsDestructable()
end
function c29201026.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and c29201026.desfilter1(chkc) end
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<-1 then return false end
        local loc=LOCATION_ONFIELD
        if ft==0 then loc=LOCATION_MZONE end
        e:SetLabel(loc)
        return Duel.IsExistingTarget(c29201026.desfilter1,tp,loc,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201026.desfilter1,tp,e:GetLabel(),0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29201026.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
            Duel.SendtoGrave(c,REASON_RULE)
        end
    end
end
function c29201026.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201026.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_DAMAGE and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
        and not Duel.IsDamageCalculated()
end
function c29201026.filter3(c)
    return c:IsSetCard(0x63e0) and c:GetBaseAttack()>0 and c:IsAbleToGrave()
end
function c29201026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(29201026)==0 end
    e:GetHandler():RegisterFlagEffect(29201026,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c29201026.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201026.filter3,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c29201026.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c29201026.filter3,tp,LOCATION_HAND,0,1,1,nil)
    if c:IsFaceup() and g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(g:GetFirst():GetBaseAttack())
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c29201026.condtion5(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0 and re:GetOwner():IsSetCard(0x63e0) 
        and e:GetHandler():IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND)
end
function c29201026.target5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201026.operation5(e,tp,eg,ep,ev,re,r,rp)
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


