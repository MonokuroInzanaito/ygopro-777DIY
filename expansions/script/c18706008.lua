--小公主
function c18706008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c18706008.efilter)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c18706008.ind2)
	c:RegisterEffect(e2)
end
function c18706008.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (re:GetHandler():GetRace()~=RACE_FIEND or re:GetHandler():GetRace()~=RACE_FAIRY)

end
function c18706008.ind2(e,c)
	return c:GetRace()~=RACE_FAIRY or c:GetRace()~=RACE_FIEND
end