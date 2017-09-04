--湖光幻影
function c10981046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10981046.cost)
	e1:SetTarget(c10981046.target)
	e1:SetOperation(c10981046.activate)
	c:RegisterEffect(e1)	
end
function c10981046.cfilter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c10981046.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c10981046.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsAbleToExtraAsCost()
		and Duel.IsExistingMatchingCard(c10981046.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()-tc:GetLevel())
end
function c10981046.spfilter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10981046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c10981046.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c10981046.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c10981046.cfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g1:GetFirst())
	e:SetLabel(g2:GetFirst():GetLevel()-g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,0,REASON_COST)
end
function c10981046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10981046.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10981046.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
