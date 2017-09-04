--少女的祈祷
function c18700350.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c18700350.cost)
	e1:SetTarget(c18700350.target)
	e1:SetOperation(c18700350.activate)
	c:RegisterEffect(e1)
end
function c18700350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c18700350.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c18700350.cfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,lv,e,tp) and c:IsSetCard(0xabb)
end
function c18700350.cfilter2(c,lv,e,tp)
	return c:IsLevelAbove(lv) and c:IsSetCard(0xabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18700350.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsSetCard(0xabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18700350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c18700350.cfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c18700350.cfilter,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c18700350.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	local d=Duel.TossDice(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18700350.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv+d,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if g:GetCount()==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end