--百合崎蜜拉
function c75646301.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646301,0))
	e1:SetCategory(0x200)
	e1:SetType(0x0040)
	e1:SetRange(0x04)
	e1:SetCountLimit(1,75646301)
	e1:SetCondition(c75646301.effcon)
	e1:SetTarget(c75646301.sptg)
	e1:SetOperation(c75646301.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646301,1))
	e2:SetCategory(0x10004)
	e2:SetType(0x0040)
	e2:SetRange(0x04)
	e2:SetCountLimit(1,7564631)
	e2:SetCondition(c75646301.effcon)
	e2:SetTarget(c75646301.drtg)
	e2:SetOperation(c75646301.drop)
	c:RegisterEffect(e2)
end
function c75646301.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3)
end
function c75646301.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75646301.cfilter,tp,0x0c,0,1,nil)
end
function c75646301.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x32c3) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646301.filter,tp,0x20+0x10,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x30)
end
function c75646301.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x4)<=0 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646301.filter,tp,0x30,0,1,1,nil,e,tp)
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,0x5)
	end
end
function c75646301.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) and c:IsAbleToRemove()
end
function c75646301.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,0x10000,nil,0,tp,1)
end
function c75646301.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,0x80,0x100)
	if Duel.Draw(p,d,0x40)>0 then
		Duel.BreakEffect()
		Duel.Hint(3,tp,503)
		local g=Duel.SelectMatchingCard(tp,c75646301.rfilter,tp,0x0c,0,1,1,nil)
		Duel.Remove(g,0x5,0x40)
	end
end