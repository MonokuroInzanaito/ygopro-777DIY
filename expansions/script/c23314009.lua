--幻界元灵 弧光
function c23314009.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23314009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CVAL_CHECK)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,23314009)
	e1:SetCost(c23314009.spcost)
	e1:SetTarget(c23314009.sptg)
	e1:SetOperation(c23314009.spop)
	e1:SetValue(c23314009.valcheck)
	c:RegisterEffect(e1)
end
function c23314009.costfilter(c)
	return c:IsSetCard(0x99e) and not c:IsCode(23314009) and c:IsAbleToGraveAsCost()
end
function c23314009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,23314009)==0 then
			Duel.RegisterFlagEffect(tp,23314009,RESET_CHAIN,0,1)
			c23314009[0]=Duel.GetMatchingGroupCount(c23314009.costfilter,tp,LOCATION_DECK,0,nil)
			c23314009[1]=0
		end
		return c23314009[0]-c23314009[1]>=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23314009.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c23314009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23314009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c23314009.valcheck(e)
	c23314009[1]=c23314009[1]+1
end