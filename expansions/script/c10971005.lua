--玄灵龙 怒荡
function c10971005.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10971005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10971005)
	e1:SetCost(c10971005.cost)
	e1:SetTarget(c10971005.sptg)
	e1:SetOperation(c10971005.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10971005,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10971005)
	e2:SetCost(c10971005.descost)
	e2:SetTarget(c10971005.target)
	e2:SetOperation(c10971005.activate)
	c:RegisterEffect(e2) 
end
function c10971005.cfilter(c)
	return c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c10971005.cfilter2(c)
	return c:IsSetCard(0x234) and not c:IsPublic()
end
function c10971005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c10971005.cfilter,tp,LOCATION_HAND,0,1,nil) 
	or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971005.cfilter2,tp,LOCATION_HAND,0,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10971005.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10971005.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10971005.spfilter(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971005.spfilter2(c,e,tp)
	return c:IsSetCard(0x234) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c10971005.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) 
		or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971005.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp)) ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10971005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10971005.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c10971005.spfilter2,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10971005.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10971005.filter(c)
	return c:IsSetCard(0x234) and c:IsAbleToHand() and c:IsFaceup()
end
function c10971005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971005.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c10971005.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10971005.filter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
