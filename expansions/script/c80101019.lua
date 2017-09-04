--刀术-花
function c80101019.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(80101019,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,80101019+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c80101019.cost1)
    e1:SetTarget(c80101019.target1)
    e1:SetOperation(c80101019.activate1)
    c:RegisterEffect(e1)
    --negate activate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101019,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCountLimit(1,80101019)
    e2:SetCondition(c80101019.condition)
    e2:SetCost(c80101019.cost)
    e2:SetTarget(c80101019.target)
    e2:SetOperation(c80101019.operation)
    c:RegisterEffect(e2)
end
function c80101019.sdfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5400) and c:IsType(TYPE_SYNCHRO)
end
function c80101019.condition(e,tp,eg,ep,ev,re,r,rp,chk)
    return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) 
		and Duel.IsExistingMatchingCard(c80101019.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80101019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80101019.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
end
function c80101019.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c80101019.repop)
end
function c80101019.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c80101019.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function c80101019.rfilter(c,e,tp)
    return c:IsSetCard(0x5400) 
        and Duel.IsExistingTarget(c80101019.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c80101019.spfilter(c,code,e,tp)
    return c:IsSetCard(0x5400) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101019.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=1 then return false end
        e:SetLabel(0)
        return Duel.CheckReleaseGroup(tp,c80101019.rfilter,1,nil,e,tp)
    end
    local g=Duel.SelectReleaseGroup(tp,c80101019.rfilter,1,1,nil,e,tp)
    local code=g:GetFirst():GetCode()
    e:SetLabel(code)
    Duel.Release(g,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c80101019.activate1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local code=e:GetLabel()
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c80101019.spfilter,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
    local sc=g:GetFirst()
    local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,e:GetHandler())
    if sc and rg:GetCount()>0 and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0  and Duel.SelectYesNo(tp,aux.Stringid(47222536,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local srg=rg:Select(tp,1,1,nil)
        Duel.Remove(srg,POS_FACEUP,REASON_EFFECT)
	end
end 
