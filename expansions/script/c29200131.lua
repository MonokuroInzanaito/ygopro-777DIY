--凋叶棕-Parallel sky
function c29200131.initial_effect(c)
    --spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(29200131,0))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e6:SetRange(LOCATION_HAND)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCondition(c29200131.spcon)
    e6:SetTarget(c29200131.sptg)
    e6:SetOperation(c29200131.spop)
    c:RegisterEffect(e6)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29200131,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(0x0081)
	e1:SetProperty(0x14000)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c29200131.target)
	e1:SetOperation(c29200131.operation)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29200131,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(0x0081)
	e3:SetCode(29200000)
	e3:SetProperty(0x14000)
	e3:SetTarget(c29200131.tdtg)
	e3:SetOperation(c29200131.tdop)
	c:RegisterEffect(e3)
end
function c29200131.filter(c)
    return c:IsSetCard(0x53e0) and c:IsAbleToDeck() and not c:IsPublic()
end
function c29200131.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp)
        and Duel.IsExistingMatchingCard(c29200131.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c29200131.tdop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(p,c29200131.filter,p,LOCATION_HAND,0,1,99,nil)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-p,g)
        local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(p)
        Duel.BreakEffect()
        Duel.Draw(p,ct,REASON_EFFECT)
        Duel.ShuffleHand(p)
    end
end
function c29200131.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200131.operation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x53e0)) then
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
    else
        Duel.MoveSequence(tc,1)
	    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
	    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
	end
end
function c29200131.cfilter(c,tp)
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c29200131.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29200131.cfilter,1,nil,tp)
end
function c29200131.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
    local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*100)
end
function c29200131.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
        if ct>0 then
            Duel.BreakEffect()
            Duel.Recover(tp,ct*100,REASON_EFFECT)
        end
    elseif c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
