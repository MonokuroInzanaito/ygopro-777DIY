--生命与死亡 决意
function c60159026.initial_effect(c)
	--Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON)
    e1:SetCondition(c60159026.condition1)
    e1:SetCost(c60159026.cost1)
    e1:SetTarget(c60159026.target1)
    e1:SetOperation(c60159026.activate1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON)
    c:RegisterEffect(e3)
	--Activate
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetCondition(c60159026.condition)
    e4:SetCost(c60159026.cost1)
    e4:SetTarget(c60159026.target)
    e4:SetOperation(c60159026.activate)
    c:RegisterEffect(e4)
	--search
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCondition(c60159026.thcon)
    e5:SetCost(c60159026.thcost)
    e5:SetTarget(c60159026.thtg)
    e5:SetOperation(c60159026.thop)
    c:RegisterEffect(e5)
end
function c60159026.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x6b24)
end
function c60159026.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(c60159026.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159026.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60159026.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c60159026.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
end
function c60159026.cfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0xab24)
end
function c60159026.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsExistingMatchingCard(c60159026.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c60159026.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c60159026.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c60159026.cfilter3(c)
    return c:IsFaceup() and (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) 
		and Duel.IsExistingMatchingCard(c60159026.cfilter4,tp,LOCATION_MZONE,0,1,c) 
end
function c60159026.cfilter4(c)
    return c:IsFaceup() and (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159026.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
    return Duel.IsExistingMatchingCard(c60159026.cfilter3,tp,LOCATION_MZONE,0,1,nil) 
		and e:GetHandler():GetTurnID()==Duel.GetTurnCount() and not e:GetHandler():IsReason(REASON_RETURN) 
		and (ph==PHASE_MAIN1 or ph<=PHASE_MAIN2)
end
function c60159026.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60159026.thfilter(c)
    return c:IsSetCard(0xba) and not c:IsCode(60159026) and c:IsAbleToHand()
end
function c60159026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159026.thop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end