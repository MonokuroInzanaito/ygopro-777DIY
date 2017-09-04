--天辉团-灾厄之蝶 蜜拉贝儿
function c29201118.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --indes
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201118.reptg)
    ea:SetValue(c29201118.repval)
    ea:SetOperation(c29201118.repop)
    c:RegisterEffect(ea)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201118,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29201118.destg)
    e1:SetOperation(c29201118.desop)
    c:RegisterEffect(e1)
    --spsummon
    local e15=Effect.CreateEffect(c)
    e15:SetDescription(aux.Stringid(29201118,0))
    e15:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e15:SetCode(EVENT_BE_BATTLE_TARGET)
    e15:SetRange(LOCATION_HAND)
    e15:SetCondition(c29201118.condition)
    e15:SetTarget(c29201118.target)
    e15:SetOperation(c29201118.operation)
    c:RegisterEffect(e15)
    --
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(29201118,1))
    e11:SetCategory(CATEGORY_POSITION)
    e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e11:SetType(EFFECT_TYPE_QUICK_O)
    e11:SetCode(EVENT_FREE_CHAIN)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCountLimit(1)
    e11:SetTarget(c29201118.postg3)
    e11:SetOperation(c29201118.posop3)
    c:RegisterEffect(e11)
    --tohand
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201118,0))
    e10:SetCategory(CATEGORY_TOHAND)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_SPSUMMON_SUCCESS)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetCountLimit(1,29201118)
    e10:SetCondition(c29201118.condition7)
    e10:SetTarget(c29201118.target7)
    e10:SetOperation(c29201118.operation7)
    c:RegisterEffect(e10)
end
function c29201118.condition7(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c29201118.target7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29201118.operation7(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c29201118.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x53e1)
end
function c29201118.filter2(c)
    return c:IsFaceup() 
end
function c29201118.postg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c29201118.filter1,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c29201118.filter2,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g1=Duel.SelectTarget(tp,c29201118.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g2=Duel.SelectTarget(tp,c29201118.filter2,tp,0,LOCATION_MZONE,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
end
function c29201118.pfilter(c,e)
    return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c29201118.posop3(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c29201118.pfilter,nil,e)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201118.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x53e1)
end
function c29201118.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c29201118.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c29201118.desfilter1(c,tp,ec)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
        and Duel.IsExistingTarget(c29201118.desfilter2,tp,LOCATION_ONFIELD,0,1,c,ec)
end
function c29201118.desfilter2(c,ec)
    return c~=ec and c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c29201118.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(c29201118.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,c29201118.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,c29201118.desfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c29201118.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function c29201118.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201118.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201118.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201118,3))
end
function c29201118.repval(e,c)
    return c29201118.repfilter(c,e:GetHandlerPlayer())
end
function c29201118.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
