--交错的情感
function c5200043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5200043+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c5200043.condition1)
	e1:SetCost(c5200043.cost)
	e1:SetTarget(c5200043.target)
	e1:SetOperation(c5200043.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5200043,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,52000431)
	e2:SetCondition(c5200043.condition)
	e2:SetCost(c5200043.cost2)
	e2:SetTarget(c5200043.target2)
	e2:SetOperation(c5200043.activate2)
	c:RegisterEffect(e2)
end
function c5200043.filter(c)
	return c:IsSetCard(0x361)  and c:IsDiscardable()
end
function c5200043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200043.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c5200043.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c5200043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c5200043.activate(e,tp,eg,ep,ev,re,r,rp)
   local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c5200043.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x361) and c:IsType(TYPE_MONSTER)
end
function c5200043.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5200043.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c5200043.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5200043.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c5200043.activate2(e,tp,eg,ep,ev,re,r,rp)
   local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,1,REASON_EFFECT)==1 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c5200043.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5200043.tfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,e:GetHandler())
end
function c5200043.tfilter(c)
	return c:IsSetCard(0x361)
end