--杜拉罕骑士与飞头蛮
function c29200998.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200998,0))
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,29200998+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c29200998.cost1)
    e1:SetTarget(c29200998.target)
    e1:SetOperation(c29200998.activate)
    c:RegisterEffect(e1)
    --revive 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200998,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(c29200998.cost5)
    e1:SetTarget(c29200998.target5)
    e1:SetOperation(c29200998.operation5)
    c:RegisterEffect(e1)
end
function c29200998.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c29200998.filter1(c)
    return c:IsSetCard(0x63e0) and c:IsDiscardable()
end
function c29200998.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsExistingMatchingCard(c29200998.filter1,tp,LOCATION_HAND,0,2,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,3,tp,LOCATION_DECK)
end
function c29200998.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g1=Duel.SelectMatchingCard(tp,c29200998.filter1,tp,LOCATION_HAND,0,2,2,nil)
    if g1:GetCount()==2 then
        Duel.SendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
        Duel.Draw(tp,3,REASON_EFFECT)
    end
end
function c29200998.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c29200998.filter(c,e,tp)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29200998.target5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29200998.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c29200998.operation5(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29200998.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
