--幼幻怪 雪鸟
function c10983005.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10983005.hspcon)
	e1:SetOperation(c10983005.hspop)
	c:RegisterEffect(e1)		
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x355))
	e2:SetValue(500)
	e2:SetCondition(c10983005.con)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c10983005.con2)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x355))
	c:RegisterEffect(e4)
end
function c10983005.spfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c10983005.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10983005.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10983005.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10983005.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10983005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1355)
end
function c10983005.con(e,tp,eg,ep,ev,re,r,rp)
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
return sum>7 or Duel.IsExistingMatchingCard(c10983005.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10983005.con2(e,tp,eg,ep,ev,re,r,rp)
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
return sum>15 or Duel.IsExistingMatchingCard(c10983005.filter,tp,LOCATION_MZONE,0,1,nil)
end
