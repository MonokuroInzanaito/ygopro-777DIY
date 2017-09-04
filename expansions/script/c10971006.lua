--玄灵龙 炽炎
function c10971006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10971006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10971006)
	e1:SetCost(c10971006.cost)
	e1:SetTarget(c10971006.sptg)
	e1:SetOperation(c10971006.spop)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10971006,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10971006)
	e2:SetCost(c10971006.descost)
	e2:SetTarget(c10971006.target)
	e2:SetOperation(c10971006.operation)
	c:RegisterEffect(e2)   
end
function c10971006.cfilter(c)
	return c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c10971006.cfilter2(c)
	return c:IsSetCard(0x234) and not c:IsPublic()
end
function c10971006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c10971006.cfilter,tp,LOCATION_HAND,0,1,nil) 
	or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971006.cfilter2,tp,LOCATION_HAND,0,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10971006.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10971006.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10971006.spfilter(c,e,tp)
	return c:IsRace(RACE_PYRO) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971006.spfilter2(c,e,tp)
	return c:IsSetCard(0x234) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c10971006.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) 
		or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971006.spfilter2,tp,LOCATION_HAND,0,1,c,e,tp)) ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10971006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10971006.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c10971006.spfilter2,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10971006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10971006.filter(c)
	return c:IsSetCard(0x234) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10971006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971006.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10971006.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10971006.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
