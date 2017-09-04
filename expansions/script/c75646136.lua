--创星的羽翼
function c75646136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c75646136.cost)
	e1:SetTarget(c75646136.target)
	e1:SetOperation(c75646136.activate)
	c:RegisterEffect(e1)
end
function c75646136.cfilter(c)
	return c:IsReleasable() and c:IsType(0x1) 
end
function c75646136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingTarget(c75646136.cfilter,tp,LOCATION_ONFIELD,0,3,nil) end
	local g=Duel.SelectTarget(tp,c75646136.cfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
	Duel.Release(g,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75646136.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c75646136.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetHandler()~=se:GetHandler()
end
function c75646136.filter(c,e,tp)
	return c:IsCode(75646123) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646136.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75646136.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetFirstMatchingCard(c75646136.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end