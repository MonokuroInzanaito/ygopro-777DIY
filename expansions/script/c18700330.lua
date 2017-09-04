--少女进化!
function c18700330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c18700330.cost)
	e1:SetTarget(c18700330.target)
	e1:SetOperation(c18700330.activate)
	c:RegisterEffect(e1)
end
function c18700330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c18700330.costfilter(c,e,tp)
	local rc=c:GetRace()
	return c:IsDiscardable() and c:IsType(TYPE_MONSTER)
		 and Duel.IsExistingMatchingCard(c18700330.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,rc)
end
function c18700330.ctfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c18700330.dfilter(c,e,tp,rc,mc,rk)
	if not Duel.IsExistingMatchingCard(c18700330.ctfilter,tp,0,LOCATION_MZONE,1,nil) then
	return c:IsRace(rc) and c:IsSetCard(0xabb) and c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and mc:IsCanBeXyzMaterial(c)
	else
	return  c:IsSetCard(0xabb) and c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and mc:IsCanBeXyzMaterial(c)
   end
end
function c18700330.tgfilter(c,e,tp,rc)
	local rk=c:GetRank()
	return c:IsSetCard(0xabb) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c18700330.dfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rc,c,rk) and c:IsFaceup()
end
function c18700330.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c18700330.filter1(chkc,e,tp) end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c18700330.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp)
	end
	e:SetLabel(0)
	---cost
	local g=Duel.SelectMatchingCard(tp,c18700330.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	local rc=g:GetFirst():GetRace()
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	---target
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18700330.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(rc)
end
function c18700330.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local rc=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18700330.dfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rc,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end