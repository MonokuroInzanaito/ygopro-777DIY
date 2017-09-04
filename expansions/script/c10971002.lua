--玄灵龙 岩铁
function c10971002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10971002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,10971002)
	e1:SetCondition(c10971002.spcon)
	e1:SetCost(c10971002.spcost)
	e1:SetTarget(c10971002.sptg)
	e1:SetOperation(c10971002.spop)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10971002,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10971002)
	e2:SetCost(c10971002.cost)
	e2:SetTarget(c10971002.target)
	e2:SetOperation(c10971002.operation)
	c:RegisterEffect(e2)  
end
function c10971002.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>1
end
function c10971002.cfilter(c)
	return c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c10971002.cfilter2(c)
	return c:IsSetCard(0x234) and not c:IsPublic()
end
function c10971002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c10971002.cfilter,tp,LOCATION_HAND,0,1,nil) 
	or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971002.cfilter2,tp,LOCATION_HAND,0,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10971002.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10971002.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10971002.spfilter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971002.spfilter2(c,e,tp)
	return c:IsSetCard(0x234) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (Duel.IsExistingMatchingCard(c10971002.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) 
		or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971002.spfilter2,tp,LOCATION_HAND,0,1,c,e,tp)) ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10971002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10971002.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c10971002.spfilter2,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10971002.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x234) and c:IsAbleToRemoveAsCost()
end
function c10971002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10971002.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c10971002.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c10971002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c10971002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,2,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end