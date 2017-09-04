--刀术-月
function c80101012.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,80101012)
    e1:SetCondition(c80101012.condition)
    e1:SetTarget(c80101012.target)
    e1:SetOperation(c80101012.activate)
    c:RegisterEffect(e1)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101012,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,80101012)
    e2:SetCondition(c80101012.negcon)
    e2:SetCost(c80101012.negcost)
    e2:SetTarget(c80101012.negtg)
    e2:SetOperation(c80101012.negop)
    c:RegisterEffect(e2)
    --negate attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80101012,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,80101012)
    e3:SetCondition(c80101012.condition1)
    e3:SetCost(c80101012.negcost)
    e3:SetTarget(c80101012.target1)
    e3:SetOperation(c80101012.operation1)
    c:RegisterEffect(e3)
end
function c80101012.condition1(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    return ec:IsFaceup() and ec:IsSetCard(0x5400)
end
function c80101012.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80101012.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chk==0 then return tg:IsOnField() end
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c80101012.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
        Duel.NegateAttack()
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c80101012.cfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101012.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c80101012.cfilter,1,nil,tp)
end
function c80101012.thfilter(c)
    return c:IsSetCard(0x6400) and c:IsAbleToHand()
end
function c80101012.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101012.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c80101012.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101012.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101012.tfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x5400) and c:IsLocation(LOCATION_MZONE)
end
function c80101012.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c80101012.tfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function c80101012.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c80101012.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
