--红色骑士团的集结
function c60158836.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60158836+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c60158836.cost)
    e1:SetTarget(c60158836.target)
    e1:SetOperation(c60158836.activate)
    c:RegisterEffect(e1)
end
function c60158836.filter(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER)
end
function c60158836.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158836.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c60158836.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c60158836.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c60158836.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
