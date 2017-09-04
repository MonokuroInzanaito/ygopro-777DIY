--凋叶棕-改-Star seeker
function c29200161.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c29200161.mfilter,2,2,c29200161.ovfilter,aux.Stringid(29200161,0),2,c29200161.xyzop)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200161,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c29200161.spcon)
    e1:SetTarget(c29200161.sptg)
    e1:SetOperation(c29200161.spop)
    c:RegisterEffect(e1)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200161,2))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c29200161.cost)
    e2:SetTarget(c29200161.target)
    e2:SetOperation(c29200161.operation)
    c:RegisterEffect(e2)
end
function c29200161.mfilter(c)
    return c:IsSetCard(0x53e0) 
end
function c29200161.ovfilter(c)
    return c:IsFaceup() and c:IsCode(29200118)
end
function c29200161.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,29200161)==0 end
    Duel.RegisterFlagEffect(tp,29200161,RESET_PHASE+PHASE_END,0,1)
end
function c29200161.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c29200161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c29200161.filter(c)
    return c:IsAbleToHand() and c:IsSetCard(0x53e0) 
end
function c29200161.spop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
    Duel.ConfirmDecktop(tp,3)
    local g=Duel.GetDecktopGroup(tp,3)
    if g:GetCount()>0 then
        Duel.DisableShuffleCheck()
        if g:IsExists(c29200161.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29200161,3)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:FilterSelect(tp,c29200161.filter,1,1,nil)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
            Duel.ShuffleHand(tp)
            g:Sub(sg)
        end
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
    end
end
function c29200161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29200161.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
        and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c29200161.filter5(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c29200161.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if ct==0 then return end
    if ct>3 then ct=3 end
    local t={}
    for i=1,ct do t[i]=i end
    local ac=Duel.AnnounceNumber(tp,table.unpack(t))
    Duel.ConfirmDecktop(tp,ac)
    local g=Duel.GetDecktopGroup(tp,ac)
    local sg=g:Filter(c29200161.filter5,nil)
    Duel.DisableShuffleCheck()
    if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,sg:GetCount(),c)
        if tg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.DisableShuffleCheck(false)
            Duel.SendtoHand(tg,nil,REASON_EFFECT)
        end
    end
    Duel.ShuffleDeck(tp)
end

