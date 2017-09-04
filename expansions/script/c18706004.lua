--noir
function c18706004.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18706004)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c18706004.target)
	e1:SetOperation(c18706004.operation)
	c:RegisterEffect(e1)
end
function c18706004.dfilter(c,rc,e,tp)
	return c:GetRank()==4 and c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c18706004.filter(c,e,tp)
	local rc=c:GetRace()
	return c:IsFaceup() and c:GetLevel()==4 
	and Duel.IsExistingMatchingCard(c18706004.dfilter,tp,LOCATION_EXTRA,0,1,nil,rc,e,tp) and not c:IsCode(18706004)
end
function c18706004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18706004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18706004.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18706004.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(g:GetFirst():GetRace())
end
function c18706004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local hc=Duel.GetFirstTarget()
	local tc=Duel.SelectMatchingCard(tp,c18706004.dfilter,tp,LOCATION_EXTRA,0,1,1,nil,hc:GetRace(),e,tp)
	local sc=tc:GetFirst()
	if sc then
		local cg=Group.FromCards(c)
		local hg=Group.FromCards(hc)
		--
		sc:SetMaterial(cg)
		sc:SetMaterial(hg)
		--
		Duel.Overlay(sc,cg)
		Duel.Overlay(sc,hg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end