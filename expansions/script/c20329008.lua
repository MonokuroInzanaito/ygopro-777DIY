--穴居者 丝命缠盘
function c20329008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20329008.cost)
	e1:SetCondition(c20329008.condition)
	e1:SetOperation(c20329008.activate)
	c:RegisterEffect(e1)
end
function c20329008.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c20329008.costfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x284)
end
function c20329008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20329008.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c20329008.costfilter,1,1,REASON_COST)
end
function c20329008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	if Duel.IsExistingMatchingCard(c20329006.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(20329006,1)) then
		local sptc=Duel.SelectMatchingCard(tp,c20329006.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.BreakEffect()
		Duel.SpecialSummon(sptc,0,tp,tp,false,false,POS_FACEUP)
	end
end