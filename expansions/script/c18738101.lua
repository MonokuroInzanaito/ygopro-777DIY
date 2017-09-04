--黑圣女 小仓朝阳
function c18738101.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e1:SetCountLimit(1,187381010)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18738101.spcon)
	e1:SetOperation(c18738101.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4939890,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,18738101)
	e2:SetCondition(c18738101.thcon)
	e2:SetTarget(c18738101.thtg)
	e2:SetOperation(c18738101.thop)
	c:RegisterEffect(e2)
end
function c18738101.spcon(e,c)
	if c==nil then return true end
	if not e:GetHandler():IsHasEffect(18738107) then
	return Duel.GetActivityCount(c:GetControler(),ACTIVITY_NORMALSUMMON)==0 
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c18738101.rmfilter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),nil)
	else
	return Duel.GetActivityCount(c:GetControler(),ACTIVITY_NORMALSUMMON)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c18738101.rmfilter,c:GetControler(),LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),nil)
	end
end
function c18738101.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if not e:GetHandler():IsHasEffect(18738107) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738101.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
	Duel.ConfirmCards(1-tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738101.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
	Duel.ConfirmCards(1-tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c18738101.rmfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x3ab0)  and c:IsType(TYPE_MONSTER)
end
function c18738101.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and (c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_DECK))
end
function c18738101.thfilter(c)
	return (c:IsSetCard(0x3ab0) or c:IsCode(18738107)) and c:IsAbleToHand() and not c:IsCode(18738106)
end
function c18738101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738101.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18738101.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18738101.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end