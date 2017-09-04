--玄灵龙 海潮
function c10971004.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75878039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10971004)
	e1:SetCost(c10971004.cost)
	e1:SetTarget(c10971004.target)
	e1:SetOperation(c10971004.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10971004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10971004)
	e2:SetCost(c10971004.cost2)
	e2:SetTarget(c10971004.target2)
	e2:SetOperation(c10971004.operation2)
	c:RegisterEffect(e2)	
end
function c10971004.cfilter(c)
	return c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c10971004.cfilter2(c)
	return c:IsSetCard(0x234) and not c:IsPublic()
end
function c10971004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c10971004.cfilter,tp,LOCATION_HAND,0,1,nil) 
	or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971004.cfilter2,tp,LOCATION_HAND,0,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10971004.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10971004.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10971004.filter(c)
	return c:IsSetCard(0x234) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10971004.filter2(c)
	return (c:IsRace(RACE_FISH) or c:IsRace(RACE_AQUA) or c:IsRace(RACE_SEASERPENT)) and c:IsAbleToHand()
end
function c10971004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971004.filter,tp,LOCATION_DECK,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,10971000)
	and Duel.IsExistingMatchingCard(c10971004.filter2,tp,LOCATION_DECK,0,1,nil)) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10971004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10971004.filter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10971004.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10971004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971004.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10971004.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10971004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10971004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
