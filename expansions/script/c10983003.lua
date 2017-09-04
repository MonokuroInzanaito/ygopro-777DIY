--中幻怪 羽蛾
function c10983003.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10983003.hspcon)
	e1:SetOperation(c10983003.hspop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x355))
	e2:SetCondition(c10983003.con)
	e2:SetValue(c10983003.efilter)
	c:RegisterEffect(e2)	  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x355))
	e3:SetCondition(c10983003.con2)
	e3:SetValue(c10983003.efilter2)
	c:RegisterEffect(e3)  
end
function c10983003.spfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(2) and c:IsAbleToRemoveAsCost()
end
function c10983003.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10983003.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10983003.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10983003.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10983003.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1355)
end
function c10983003.con(e,tp,eg,ep,ev,re,r,rp)
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
return sum>11 or Duel.IsExistingMatchingCard(c10983003.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10983003.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) 
end
function c10983003.con2(e,tp,eg,ep,ev,re,r,rp)
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
return sum>19 or Duel.IsExistingMatchingCard(c10983003.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10983003.efilter2(e,te)
	return (te:IsActiveType(TYPE_RITUAL) or te:IsActiveType(TYPE_FUSION)
	or te:IsActiveType(TYPE_SYNCHRO) or te:IsActiveType(TYPE_XYZ))
end
