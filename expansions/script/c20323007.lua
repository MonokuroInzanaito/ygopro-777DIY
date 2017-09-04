function c20323007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FISH),4,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(20323007,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,20323007)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20323007.cost)
	e1:SetTarget(c20323007.target)
	e1:SetOperation(c20323007.operation)
	c:RegisterEffect(e1)
	--ATTRIBUTE
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetCondition(c20323007.con)
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
end
function c20323007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20323007.filter(c,e,tp)
	return c:IsRace(RACE_FISH) and Duel.IsExistingMatchingCard(c20323007.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttack())
end
function c20323007.filter2(c,e,tp,atk)
	return c:IsRace(RACE_FISH) and c:GetBaseAttack()<atk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20323007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c20323007.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c20323007.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20323007.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.GetFirstTarget()
		local atk=tc:GetAttack()
		local g=Duel.SelectMatchingCard(tp,c20323007.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,atk)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c20323007.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0
end