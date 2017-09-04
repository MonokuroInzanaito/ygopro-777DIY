--地耀团-赤蔷薇 娜特莉
function c29201108.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201108.reptg)
    ea:SetValue(c29201108.repval)
    ea:SetOperation(c29201108.repop)
    c:RegisterEffect(ea)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201108,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,29201108)
    e1:SetCondition(c29201108.spcon)
    e1:SetOperation(c29201108.spop)
    c:RegisterEffect(e1)
    --position change
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c29201108.postg)
    e2:SetOperation(c29201108.posop)
    c:RegisterEffect(e2)
    --pos
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(29201108,0))
    e11:SetCategory(CATEGORY_DESTROY)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e11:SetCode(EVENT_CHANGE_POS)
    e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e11:SetRange(LOCATION_PZONE)
    e11:SetCountLimit(1)
    e11:SetCondition(c29201108.poscon5)
    e11:SetTarget(c29201108.postg5)
    e11:SetOperation(c29201108.posop5)
    c:RegisterEffect(e11)
end
function c29201108.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x33e1) and not c:IsCode(29201108) and c:IsAbleToHandAsCost()
end
function c29201108.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c29201108.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29201108.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201108.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c29201108.filter(c,sp)
    return c:GetSummonPlayer()==sp
end
function c29201108.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201108.filter,1,nil,1-tp) end
    local g=eg:Filter(c29201108.filter,nil,1-tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c29201108.posop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    local og=Duel.GetOperatedGroup()
    local tc=og:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        tc=og:GetNext()
    end
end
function c29201108.cfilter(c,tp)
    local np=c:GetPosition()
    local pp=c:GetPreviousPosition()
    return ((np==POS_FACEUP_DEFENSE and pp==POS_FACEUP_ATTACK) or (bit.band(pp,POS_DEFENSE)~=0 and np==POS_FACEUP_ATTACK))
        and c:IsControler(tp) and c:IsSetCard(0x33e1)
end
function c29201108.poscon5(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201108.cfilter,1,nil,tp)
end
function c29201108.thfilter(c)
    return c:IsSetCard(0x33e1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29201108.postg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29201108.posop5(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c29201108.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x33e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201108.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201108.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201108,3))
end
function c29201108.repval(e,c)
    return c29201108.repfilter(c,e:GetHandlerPlayer())
end
function c29201108.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

