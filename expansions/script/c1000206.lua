--虹纹的交换
function c1000206.initial_effect(c)
	--① 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1000206)
	e1:SetCost(c1000206.cost)
	e1:SetTarget(c1000206.target)
	e1:SetOperation(c1000206.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(1000206,ACTIVITY_SPSUMMON,c1000206.counterfilter)
end
function c1000206.counterfilter(c)
	return c:IsSetCard(0x200)
end
function c1000206.filter(c)
	return c:IsSetCard(0x3200) and c:IsAbleToRemoveAsCost()
end
function c1000206.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000206.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetCustomActivityCount(1000206,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1000206.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c1000206.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c1000206.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x200)
end
function c1000206.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c1000206.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
