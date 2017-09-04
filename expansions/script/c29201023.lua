--镜世录 恋鬼胎
function c29201023.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(29201023,0))
    e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_PZONE)
    e11:SetCost(c29201023.spcost)
    e11:SetTarget(c29201023.sptg)
    e11:SetOperation(c29201023.spop)
    c:RegisterEffect(e11)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c29201023.pencon)
    e4:SetTarget(c29201023.pentg)
    e4:SetOperation(c29201023.penop)
    c:RegisterEffect(e4)
    --level
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c29201023.target)
    e3:SetOperation(c29201023.operation)
    c:RegisterEffect(e3)
    --battle target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c29201023.adcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c29201023.adcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_CANNOT_TO_GRAVE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
    c:RegisterEffect(ea)
    --
    local eb=Effect.CreateEffect(c)
    eb:SetType(EFFECT_TYPE_FIELD)
    eb:SetCode(EFFECT_CANNOT_DISCARD_DECK)
    eb:SetRange(LOCATION_PZONE)
    eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    eb:SetTargetRange(1,1)
    c:RegisterEffect(eb)
	----
    local ec=Effect.CreateEffect(c)
    ec:SetType(EFFECT_TYPE_FIELD)
    ec:SetCode(EFFECT_CANNOT_REMOVE)
    ec:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    ec:SetRange(LOCATION_PZONE)
    ec:SetTargetRange(1,1)
    c:RegisterEffect(ec)
    --
    local ed=Effect.CreateEffect(c)
    ed:SetType(EFFECT_TYPE_FIELD)
    ed:SetCode(EFFECT_CANNOT_REMOVE)
    ed:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    ed:SetRange(LOCATION_MZONE)
    ed:SetTargetRange(1,1)
    c:RegisterEffect(ed)
    --29201023 chk
    local ee=Effect.CreateEffect(c)
    ee:SetType(EFFECT_TYPE_FIELD)
    ee:SetCode(29201023)
    ee:SetRange(LOCATION_MZONE)
    ee:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    ee:SetTargetRange(1,1)
    c:RegisterEffect(ee)
    --29201023 chk--
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(29201023)
    e10:SetRange(LOCATION_PZONE)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetTargetRange(1,1)
    c:RegisterEffect(e10)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_PZONE)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201023.splimit)
    c:RegisterEffect(e12)
end
function c29201023.splimit(e,c,tp,sumtp,sumpos)
    local seq=e:GetHandler():GetSequence()
    local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
    if tc and not tc:IsSetCard(0x63e0) then
        return true
    else
        return false
    end
end
function c29201023.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c29201023.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201023.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201023.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c29201023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201023.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c29201023.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201023.desfilter(c)
    return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x63e0) and c:IsDestructable()
end
function c29201023.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c29201023.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201023.desfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201023.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29201023.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29201023.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) 
end
function c29201023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c29201023.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c29201023.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    Duel.SelectTarget(tp,c29201023.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c29201023.efilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
end
function c29201023.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c29201023.efilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
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
    end
end
function c29201023.afilter(c)
    return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c29201023.adcon(e)
    return Duel.IsExistingMatchingCard(c29201023.afilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
