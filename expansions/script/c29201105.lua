--地耀团-苍炎魔法使 维尔拉
function c29201105.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201105.reptg)
    ea:SetValue(c29201105.repval)
    ea:SetOperation(c29201105.repop)
    c:RegisterEffect(ea)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201105,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c29201105.condition)
    e1:SetTarget(c29201105.target)
    e1:SetOperation(c29201105.operation)
    c:RegisterEffect(e1)
    --pos
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201105,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_CHANGE_POS)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetCondition(c29201105.poscon)
    e2:SetTarget(c29201105.postg)
    e2:SetOperation(c29201105.posop)
    c:RegisterEffect(e2)
    --swap2
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201105,2))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCondition(c29201105.adcon2)
    e3:SetTarget(c29201105.adtg2)
    e3:SetOperation(c29201105.adop2)
    c:RegisterEffect(e3)
end
function c29201105.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x33e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201105.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201105.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201105,3))
end
function c29201105.repval(e,c)
    return c29201105.repfilter(c,e:GetHandlerPlayer())
end
function c29201105.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201105.cfilter(c,tp)
    local np=c:GetPosition()
    local pp=c:GetPreviousPosition()
    return ((np==POS_FACEUP_DEFENSE and pp==POS_FACEUP_ATTACK) or (bit.band(pp,POS_DEFENSE)~=0 and np==POS_FACEUP_ATTACK))
        and c:IsControler(tp) and c:IsSetCard(0x33e1)
end
function c29201105.poscon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201105.cfilter,1,nil,tp)
end
function c29201105.filter(c)
    return not c:IsPosition(POS_FACEUP_DEFENSE)
end
function c29201105.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c29201105.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201105.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    Duel.SelectTarget(tp,c29201105.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c29201105.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsPosition(POS_FACEUP_DEFENSE) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
        if not tc:IsSetCard(0x33e1) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_EFFECT)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e3)
        end
    end
end
function c29201105.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x33e1)
end
function c29201105.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c29201105.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.BreakEffect()
            Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
        end
    elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c29201105.adcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function c29201105.adtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29201105.adop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e)
        and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SWAP_AD)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end




