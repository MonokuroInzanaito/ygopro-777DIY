--镜世录 黑狼神
function c29201066.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201066,5))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201066.pencon)
    e7:SetTarget(c29201066.pentg)
    e7:SetOperation(c29201066.penop)
    c:RegisterEffect(e7)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1,0)
    e12:SetCondition(c29201066.splimcon)
    e12:SetTarget(c29201066.splimit)
    c:RegisterEffect(e12)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201066,1))
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c29201066.thtg)
    e2:SetOperation(c29201066.thop)
    c:RegisterEffect(e2)
    local ea=e2:Clone()
    ea:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(ea)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c29201066.target)
    e3:SetValue(c29201066.indct)
    c:RegisterEffect(e3)
end
function c29201066.target(e,c)
    return c:IsSetCard(0x63e0)
end
function c29201066.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
        return 1
    else return 0 end
end
function c29201066.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201066.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c29201066.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29201066.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c29201066.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x63e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201066.filter(c)
    return c:IsSetCard(0x63e0) and c:IsSummonable(true,nil)
end
function c29201066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201066.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c29201066.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201066.filter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Summon(tp,g:GetFirst(),true,nil)
    end
end

