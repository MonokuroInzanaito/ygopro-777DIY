--穴居者 崖落巨石
function c20329007.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c20329007.cost)
	e1:SetTarget(c20329007.target)
	e1:SetOperation(c20329007.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetCost(c20329007.cost)
	e2:SetTarget(c20329007.target)
	e2:SetOperation(c20329007.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c20329007.cost)
	e3:SetTarget(c20329007.target2)
	e3:SetOperation(c20329007.activate2)
	c:RegisterEffect(e3)
end
function c20329007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c20329007.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
		and ep~=tp and c:IsAbleToRemove()
end
function c20329007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c20329007.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c20329007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c20329007.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(20329007,1)) then
			local sptc=Duel.SelectMatchingCard(tp,c20329007.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(sptc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c20329007.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and c:GetSummonPlayer()~=tp
		and c:IsAbleToRemove()
end
function c20329007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c20329007.filter2,1,nil,tp) end
	local g=eg:Filter(c20329007.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c20329007.filter3(c,e,tp)
	return c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c20329007.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c20329007.filter3,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		tc=g:GetNext()
		end
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c20329007.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(20329007,1)) then
			local sptc=Duel.SelectMatchingCard(tp,c20329007.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(sptc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c20329007.spfilter(c,e,tp)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end