--镜世录 凋澪花
function c29201013.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1,0)
    e12:SetCondition(c29201013.splimcon)
    e12:SetTarget(c29201013.splimit)
    c:RegisterEffect(e12)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(c29201013.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --spsummon
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_SPSUMMON_PROC)
    e10:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e10:SetRange(LOCATION_HAND)
    e10:SetCondition(c29201013.spcon)
    c:RegisterEffect(e10)
    --tuner
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201013,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,29201013)
    e1:SetTarget(c29201013.target)
    e1:SetOperation(c29201013.operation)
    c:RegisterEffect(e1)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201013,5))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201013.pencon)
    e7:SetTarget(c29201013.pentg)
    e7:SetOperation(c29201013.penop)
    c:RegisterEffect(e7)
end
function c29201013.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c29201013.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x63e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201013.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201013.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c29201013.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29201013.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
function c29201013.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201013.cfilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function c29201013.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and not c:IsType(TYPE_TUNER)
end
function c29201013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29201013.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201013.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c29201013.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29201013.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
    end
end
function c29201013.tgtg(e,c)
    return c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
