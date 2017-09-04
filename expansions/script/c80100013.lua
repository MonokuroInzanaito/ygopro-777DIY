--幻想物语 至高的蔷薇
function c80100013.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetCondition(c80100013.splimcon)
    e2:SetTarget(c80100013.splimit)
    c:RegisterEffect(e2)
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,80100013)
    e1:SetTarget(c80100013.pctg)
    e1:SetOperation(c80100013.pcop)
    c:RegisterEffect(e1)
    --cannot target
    local eb=Effect.CreateEffect(c)
    eb:SetType(EFFECT_TYPE_SINGLE)
    eb:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    eb:SetRange(LOCATION_PZONE)
    eb:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    eb:SetCondition(c80100013.limcon)
    eb:SetValue(aux.tgoval)
    c:RegisterEffect(eb)
    --indes
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetCondition(c80100013.limcon)
    ea:SetValue(c80100013.indval)
    c:RegisterEffect(ea)
end
function c80100013.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3400)
end
function c80100013.limcon(e)
    return Duel.IsExistingMatchingCard(c80100013.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80100013.indval(e,re,tp)
    return tp~=e:GetHandlerPlayer()
end
function c80100013.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c80100013.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x3400) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80100013.pcfilter(c)
    return c:IsCode(80100012) and not c:IsForbidden()
end
function c80100013.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    local seq=e:GetHandler():GetSequence()
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
        and Duel.IsExistingMatchingCard(c80100013.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c80100013.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local seq=e:GetHandler():GetSequence()
    if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c80100013.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
