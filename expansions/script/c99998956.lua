--旅途的开端
function c99998956.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99998956.condition)
	e1:SetCost(c99998956.spcost)
	e1:SetTarget(c99998956.sptg)
	e1:SetOperation(c99998956.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99998956,ACTIVITY_SPSUMMON,c99998956.counterfilter)
end
function c99998956.counterfilter(c)
	return c:IsLocation(LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c99998956.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c99998956.costfilter(c)
	return  c:IsDiscardable()
end
function c99998956.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998956.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) 
	and Duel.GetCustomActivityCount(99998956,tp,ACTIVITY_SPSUMMON)==0  end
	Duel.DiscardHand(tp,c99998956.costfilter,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(e)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99998956.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99998956.exsplimit)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c99998956.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return  c:IsLocation(LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE) and se~=e:GetLabelObject()
end
function c99998956.exsplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return  c:IsLocation(LOCATION_EXTRA) 
end
function c99998956.spfilter(c,e,tp)
	return  c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99998956.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then local g=Duel.GetMatchingGroup(c99998956.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99998956.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99998956.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)<3 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg1=g:Select(tp,1,1,nil)
	    g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg2=g:Select(tp,1,1,nil)
	    g:Remove(Card.IsCode,nil,tg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg3=g:Select(tp,1,1,nil)
	    g:Remove(Card.IsCode,nil,tg3:GetFirst():GetCode())
		tg1:Merge(tg2)
		tg1:Merge(tg3)
		Duel.ConfirmCards(1-tp,tg1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg1:Select(1-tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end