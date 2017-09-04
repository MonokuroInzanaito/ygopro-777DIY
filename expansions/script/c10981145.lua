--元素之灵的起源者
function c10981145.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10981145.spcon)
	c:RegisterEffect(e1)	
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(10981145)
    c:RegisterEffect(e3)
end
function c10981145.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x358) and c:IsType(TYPE_SYNCHRO)
end
function c10981145.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10981145.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
