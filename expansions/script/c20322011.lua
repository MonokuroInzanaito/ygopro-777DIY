--巨怪工厂 实验品
function c20322011.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c20322011.hspcon)
	e1:SetOperation(c20322011.hspop)
	c:RegisterEffect(e1)
	--active(spsummon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c20322011.target)
	e2:SetOperation(c20322011.operation)
	c:RegisterEffect(e2)
end
function c20322011.hspfilter(c)
	return c:GetLevel()>=10 and c:IsAbleToDeck()
end
function c20322011.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(c20322011.hspfilter,c:GetControler(),LOCATION_HAND,0,c)>0
end
function c20322011.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(c:GetControler(),c20322011.hspfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c20322011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c20322011.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x282) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER)
end
function c20322011.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0x282) and c:IsLevelAbove(10) and c:IsType(TYPE_MONSTER)
end
function c20322011.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=0
	if Duel.IsExistingMatchingCard(c20322011.filter1,tp,LOCATION_DECK,0,1,nil) then p=p+1 end
	if Duel.IsExistingMatchingCard(c20322011.filter2,tp,LOCATION_GRAVE,0,1,nil) then p=p+2 end
	if p==0 then return end
	if p==3 then p=Duel.SelectOption(tp,aux.Stringid(20322011,0),aux.Stringid(20322011,1))+1 end
	if p==1 then 
		local g=Duel.SelectMatchingCard(tp,c20322011.filter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if p==2 then 
		local g=Duel.SelectMatchingCard(tp,c20322011.filter2,tp,LOCATION_GRAVE,0,1,1,nil)	  
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end