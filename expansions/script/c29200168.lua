--凋叶棕-改-胎儿之梦
function c29200168.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c29200168.mfilter,4,2,c29200168.ovfilter,aux.Stringid(29200168,0),2,c29200168.xyzop)
    c:EnableReviveLimit()
    --to deck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200168,3))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c29200168.tdcon)
    e3:SetTarget(c29200168.tdtg)
    e3:SetOperation(c29200168.tdop)
    c:RegisterEffect(e3)
    --ret&draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200168,1))
    e1:SetCategory(CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e1:SetCost(c29200168.cost)
    e1:SetTarget(c29200168.target1)
    e1:SetOperation(c29200168.operation1)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200168,2))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCost(c29200168.cost)
    e2:SetTarget(c29200168.target2)
    e2:SetOperation(c29200168.operation2)
    c:RegisterEffect(e2)
end
function c29200168.mfilter(c)
    return c:IsSetCard(0x53e0) 
end
function c29200168.ovfilter(c)
    return c:IsFaceup() and c:IsCode(29200109)
end
function c29200168.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,29200168)==0 end
    Duel.RegisterFlagEffect(tp,29200168,RESET_PHASE+PHASE_END,0,1)
end
function c29200168.cfilter(c,tp)
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c29200168.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29200168.cfilter,1,nil,tp)
end
function c29200168.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c29200168.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function c29200168.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29200168.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(5)
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function c29200168.cfilter1(c)
    return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c29200168.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.DiscardDeck(p,d,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local ct=g:FilterCount(c29200168.cfilter1,nil)
    if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetValue(ct*200)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c29200168.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function c29200168.filter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c29200168.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmDecktop(tp,3)
    local g=Duel.GetDecktopGroup(tp,3)
    local ct=g:FilterCount(c29200168.filter,nil)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
    if ct>0 and sg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local dg=sg:Select(tp,1,ct,nil)
        Duel.HintSelection(dg)
        --Duel.Destroy(dg,REASON_EFFECT)
        Duel.SendtoGrave(dg,REASON_EFFECT)
        Duel.BreakEffect()
    end
    Duel.SortDecktop(tp,tp,3)
end

