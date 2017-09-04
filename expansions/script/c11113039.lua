--女武神的赠礼
function c11113039.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113039+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11113039.cost)
	e1:SetTarget(c11113039.target)
	e1:SetOperation(c11113039.activate)
	c:RegisterEffect(e1)
end
function c11113039.cfilter(c)
	return c:IsSetCard(0x15c) and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsAbleToRemoveAsCost()
end
function c11113039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113039.cfilter,tp,LOCATION_SZONE,0,2,nil) end
	local g=Duel.GetMatchingGroup(c11113039.cfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11113039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c11113039.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
	    Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end