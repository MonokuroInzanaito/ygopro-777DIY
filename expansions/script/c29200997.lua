--就算死也要保护你
function c29200997.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,29200997+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c29200997.cost)
    e1:SetTarget(c29200997.target)
    e1:SetOperation(c29200997.activate)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c29200997.discon)
    e2:SetCost(c29200997.discost)
    e2:SetTarget(c29200997.distg)
    e2:SetOperation(c29200997.disop)
    c:RegisterEffect(e2)
    if not c29200997.global_check then
        c29200997.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c29200997.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c29200997.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local p1=false
    local p2=false
    while tc do
        if not tc:IsSetCard(0x63e0) then
            if tc:GetSummonPlayer()==0 then p1=true else p2=true end
        end
        tc=eg:GetNext()
    end
    if p1 then Duel.RegisterFlagEffect(0,29200997,RESET_PHASE+PHASE_END,0,1) end
    if p2 then Duel.RegisterFlagEffect(1,29200997,RESET_PHASE+PHASE_END,0,1) end
end
function c29200997.counterfilter(c)
    return c:IsSetCard(0x63e0)
end
function c29200997.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) 
       and Duel.GetFlagEffect(tp,29200997)==0 end
    Duel.DiscardDeck(tp,3,REASON_COST)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c29200997.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c29200997.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x63e0)
end
function c29200997.filter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29200997.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200997.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29200997.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29200997.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c29200997.tgfilter(c,tp)
    return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsSetCard(0x63e0)
end
function c29200997.discon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return tg and tg:IsExists(c29200997.tgfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c29200997.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c29200997.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c29200997.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end

