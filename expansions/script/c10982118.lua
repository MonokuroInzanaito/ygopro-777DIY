--崩坏的终之空
function c10982118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10982118.cost)
	e1:SetTarget(c10982118.target)
	e1:SetOperation(c10982118.activate)
	c:RegisterEffect(e1)
end
function c10982118.cfilter(c)
    return c:IsSetCard(0x4236) and c:IsType(TYPE_FUSION) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c10982118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c10982118.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c10982118.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c10982118.chkfilter1(c,e,tp)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_MONSTER) and 
		  Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c)
		and Duel.IsExistingMatchingCard(c10982118.chkfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c10982118.chkfilter2(c,e,tp,cd)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
		 and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,1-tp,c)
end
function c10982118.filter1(c,e,tp)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.IsExistingMatchingCard(c10982118.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c10982118.filter2(c,e,tp,cd)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_ATTACK,1-tp)
end
function c10982118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
		and Duel.IsExistingMatchingCard(c10982118.chkfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c10982118.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local sg=Duel.GetMatchingGroup(c10982118.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10982118,2))
		local g1=sg:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10982118,3))
		local g2=Duel.SelectMatchingCard(tp,c10982118.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,true,true,POS_FACEUP_ATTACK)
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,true,true,POS_FACEUP_ATTACK)
		Duel.SpecialSummonComplete()
	end
end
