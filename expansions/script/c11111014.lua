--魔王的随从 阿露露
function c11111014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11111014)
	e1:SetCondition(c11111014.spcon)
	c:RegisterEffect(e1)
	--race fairy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FAIRY)
	c:RegisterEffect(e2)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c11111014.xyzlimit)
	c:RegisterEffect(e3)
end
function c11111014.filter(c)
	return c:IsFaceup() and not c:IsCode(11111014) and c:GetLevel()==8 and c:IsSetCard(0x15d)
end
function c11111014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111014.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c11111014.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x15d)
end