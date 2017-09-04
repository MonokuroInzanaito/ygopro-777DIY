--凋叶棕-Demon Strundum
function c29200130.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x53e0),aux.NonTuner(Card.IsSetCard,0x53e0),1)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c29200130.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --search
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29200130,0))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e8:SetCode(EVENT_ATTACK_ANNOUNCE)
    e8:SetCountLimit(1,29200130)
    e8:SetTarget(c29200130.target)
    e8:SetOperation(c29200130.operation)
    c:RegisterEffect(e8)
    --discard deck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200130,2))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCategory(CATEGORY_DECKDES)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c29200130.discon)
    e3:SetTarget(c29200130.distg)
    e3:SetOperation(c29200130.disop)
    c:RegisterEffect(e3)
end
function c29200130.discon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c29200130.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c29200130.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function c29200130.indtg(e,c)
    return c:IsSetCard(0x53e0) and not c:IsCode(29200130)
end
function c29200130.filter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29200130.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200130.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29200130.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.GetFirstMatchingCard(c29200130.filter,tp,LOCATION_DECK,0,nil)
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
