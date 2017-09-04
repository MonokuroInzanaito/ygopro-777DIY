--镜世录 赤骑士
function c29201010.initial_effect(c)
    c:SetSPSummonOnce(29201010)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201010,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCost(c29201010.spcost)
    e1:SetTarget(c29201010.sptg)
    e1:SetOperation(c29201010.spop)
    c:RegisterEffect(e1)
    --level
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c29201010.target)
    e3:SetOperation(c29201010.operation)
    c:RegisterEffect(e3)
    --atk6
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c29201010.atktg)
    e2:SetValue(600)
    c:RegisterEffect(e2)
    --atk
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_UPDATE_ATTACK)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_MZONE,0)
    e12:SetCondition(c29201010.atkcon)
    e12:SetTarget(c29201010.atktg)
    e12:SetValue(600)
    c:RegisterEffect(e12)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c29201010.pencon)
    e4:SetTarget(c29201010.pentg)
    e4:SetOperation(c29201010.penop)
    c:RegisterEffect(e4)
end
function c29201010.atkcon(e)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c29201010.atktg(e,c)
    return c:IsSetCard(0x63e0)
end
function c29201010.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c29201010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201010.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201010.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c29201010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201010.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c29201010.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) 
end
function c29201010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c29201010.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c29201010.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    Duel.SelectTarget(tp,c29201010.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c29201010.filter8(c)
    return c:IsDestructable()
end
function c29201010.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local g=Duel.SelectMatchingCard(tp,c29201010.filter8,tp,0,LOCATION_ONFIELD,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end
function c29201010.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201010.desfilter(c)
    return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x63e0) and c:IsDestructable()
end
function c29201010.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c29201010.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201010.desfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201010.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29201010.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end