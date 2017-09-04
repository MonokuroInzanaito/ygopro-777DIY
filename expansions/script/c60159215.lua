--暂眠
function c60159215.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60159215+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60159215.condition)
    e1:SetTarget(c60159215.target)
    e1:SetOperation(c60159215.activate)
    c:RegisterEffect(e1)
end
function c60159215.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5b25)
end
function c60159215.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60159215.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159215.tgfilter(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60159215.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159215.tgfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159215.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159215.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
    end
end
