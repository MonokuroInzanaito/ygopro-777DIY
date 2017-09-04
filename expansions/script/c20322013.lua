--巨怪工厂 矿工
function c20322013.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c20322013.hspcon)
	e1:SetOperation(c20322013.hspop)
	c:RegisterEffect(e1)
	--active(spsummon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c20322013.target)
	e2:SetOperation(c20322013.operation)
	c:RegisterEffect(e2)
end
function c20322013.hspfilter(c)
	return c:GetLevel()>=10 and c:IsAbleToDeck()
end
function c20322013.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(c20322013.hspfilter,c:GetControler(),LOCATION_HAND,0,c)>0
end
function c20322013.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(c:GetControler(),c20322013.hspfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c20322013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c20322013.filter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x282) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function c20322013.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c20322013.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=0
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c20322013.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) then p=p+1 end
	if Duel.IsExistingMatchingCard(c20322013.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then p=p+2 end
	if p==3 then p=Duel.SelectOption(tp,aux.Stringid(20322013,0),aux.Stringid(20322013,1))+1 end
	if p==1 then 
		local g=Duel.SelectMatchingCard(tp,c20322013.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
	if p==2 then 
		local g=Duel.SelectMatchingCard(tp,c20322013.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end