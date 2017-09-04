--玄灵龙 木烬
function c10971003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10971003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10971003)
	e1:SetCost(c10971003.cost)
	e1:SetTarget(c10971003.sptg)
	e1:SetOperation(c10971003.spop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10971003,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10971003)
	e2:SetCost(c10971003.descost)
	e2:SetTarget(c10971003.target)
	e2:SetOperation(c10971003.activate)
	c:RegisterEffect(e2)
end
function c10971003.cfilter(c)
	return c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c10971003.cfilter2(c)
	return c:IsSetCard(0x234) and not c:IsPublic()
end
function c10971003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c10971003.cfilter,tp,LOCATION_HAND,0,1,nil) 
	or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971003.cfilter2,tp,LOCATION_HAND,0,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10971003.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10971003.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10971003.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971003.spfilter2(c,e,tp)
	return c:IsSetCard(0x234) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c10971003.spfilter,tp,LOCATION_DECK,0,1,c,e,tp) 
		or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971003.spfilter2,tp,LOCATION_DECK,0,1,c,e,tp)) ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10971003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10971003.spfilter,tp,LOCATION_DECK,0,1,1,c,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c10971003.spfilter2,tp,LOCATION_DECK,0,1,1,c,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c10971003.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10971003.filter(c)
	return c:IsSetCard(0x234) and c:IsAbleToHand()
end
function c10971003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971003.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c10971003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10971003.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end