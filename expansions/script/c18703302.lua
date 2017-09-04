--2
function c18703302.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,18703302)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c18703302.target)
	e3:SetOperation(c18703302.operation)
	c:RegisterEffect(e3)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95027497,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,18703302)
	e3:SetTarget(c18703302.ptarget)
	e3:SetOperation(c18703302.poperation)
	c:RegisterEffect(e3)
	--direct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,1870810020)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCost(c18703302.cost)
	e4:SetTarget(c18703302.sptg)
	e4:SetOperation(c18703302.spop)
	c:RegisterEffect(e4)
end
function c18703302.mat_check(c)
	return not c:IsCode(111111)
end
function c18703302.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18703302.scfilter(c,e,tp)
	return (c:GetSequence()==6 or c:GetSequence()==7)
		and (c:IsSetCard(0xabb) or c:IsSetCard(0xcab2)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c18703302.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c18703302.scfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18703302.scfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18703302.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(c18703302.scfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c18703302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c18703302.defilter,tp,LOCATION_EXTRA,0,1,nil,7,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18703302.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local slv=7
	local sg=Duel.GetMatchingGroup(c18703302.defilter,tp,LOCATION_EXTRA,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(18703302,1))
	Duel.SpecialSummonComplete()
end
function c18703302.ptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18703302.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c18703302.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18703302.poperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18703302.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Release(g,REASON_EFFECT)
	local cg=Duel.SelectMatchingCard(tp,c18703302.defilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,2,nil,tp)
	local tc1=cg:GetFirst()
	if tc1 then
		Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	local tc2=cg:GetNext()
	if tc2 then
		Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c18703302.defilter(c)
	return c:IsSetCard(0xcab2) and c:IsType(TYPE_PENDULUM)
end
function c18703302.desfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end