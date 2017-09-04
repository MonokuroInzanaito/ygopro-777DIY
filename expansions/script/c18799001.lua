--先代
function c18799001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab0),4,2)
	c:EnableReviveLimit()
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c18799001.dscon)
	c:RegisterEffect(e1)
	--local e3=Effect.CreateEffect(c)
   -- e3:SetType(EFFECT_TYPE_FIELD)
   -- e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
   -- e3:SetCode(EFFECT_CANNOT_ACTIVATE)
   -- e3:SetRange(LOCATION_MZONE)
   -- e3:SetTargetRange(0,1)
   -- e3:SetValue(c18799001.aclimit)
   -- c:RegisterEffect(e3)
	--POS
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c18799001.cost)
	e1:SetTarget(c18799001.target)
	e1:SetOperation(c18799001.operation)
	c:RegisterEffect(e1)
	--indestructable by effect
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e2:SetCondition(c18799001.condition)
	--e2:SetValue(1)
	--c:RegisterEffect(e2)
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18799001.efilter)
	c:RegisterEffect(e1)
end
function c18799001.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsLocation(LOCATION_SZONE) and rc:IsFacedown()
end
function c18799001.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c18799001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(18799010)
end
function c18799001.dscon(e)
	return e:GetHandler():IsFaceup()
end
function c18799001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18799001.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c18799001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c18799001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18799001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18799001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c18799001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end