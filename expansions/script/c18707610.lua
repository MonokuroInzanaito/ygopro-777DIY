--獅心王 立华奏
function c18707610.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaab1),4,2)
	c:EnableReviveLimit()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18707610.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83986578,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,18707610)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c18707610.condition)
	e1:SetTarget(c18707610.target)
	e1:SetOperation(c18707610.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,18707610)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c18707610.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),LOCATION_MZONE,1)*300
end
function c18707610.cfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(2000) and not c:IsType(TYPE_TOKEN)
end
function c18707610.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18707610.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c18707610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local g=eg:Filter(c18707610.cfilter,nil)
	Duel.SetTargetCard(eg)
end
function c18707610.filter(c,e)
	return c:IsFaceup() and c:IsAttackBelow(2000) and c:IsRelateToEffect(e)
end
function c18707610.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c18707610.filter,nil,e)
	if g:GetFirst():GetOverlayCount()>0 then Duel.SendtoGrave(g:GetFirst():GetOverlayGroup(),REASON_RULE) end
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end