--高原的魔女 阿兹萨·爱伊萨瓦
function c10981098.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(c10981098.value)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10981098.spcon)
	c:RegisterEffect(e2)   
end
function c10981098.lvfilter(c)
	return c:GetLevel()==1
end
function c10981098.value(e,c)
	return Duel.GetMatchingGroupCount(c10981098.lvfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*-1
end
function c10981098.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10981098.lvfilter,tp,LOCATION_GRAVE,0,12,nil)
end