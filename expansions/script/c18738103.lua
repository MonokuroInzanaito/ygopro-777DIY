--黑圣女 绯堂真寻
function c18738103.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e1:SetCountLimit(1,187381030)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18738103.spcon)
	e1:SetOperation(c18738103.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4939890,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,18738103)
	e2:SetCondition(c18738103.thcon)
	e2:SetTarget(c18738103.thtg)
	e2:SetOperation(c18738103.thop)
	c:RegisterEffect(e2)
end
function c18738103.spcon(e,c)
	if c==nil then return true end
	if not e:GetHandler():IsHasEffect(18738107) then
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c18738103.spfilter,c:GetControler(),LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(c18738103.rmfilter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),nil)
	else
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c18738103.spfilter,c:GetControler(),LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(c18738103.rmfilter,c:GetControler(),LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler(),nil)
	end
end
function c18738103.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if not e:GetHandler():IsHasEffect(18738107) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738103.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
	Duel.ConfirmCards(1-tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738103.rmfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
	Duel.ConfirmCards(1-tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	end
end
function c18738103.spfilter(c)
	return c:IsFacedown()
end
function c18738103.rmfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x3ab0) and c:IsType(TYPE_MONSTER)
end
function c18738103.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and (c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_DECK))
end
function c18738103.filter(c,e,tp)
	return c:IsSetCard(0x3ab0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18738103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18738103.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18738103.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18738103.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.ConfirmCards(1-tp,g)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end