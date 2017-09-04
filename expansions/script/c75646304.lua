--萨尔瓦
function c75646304.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x20008)
	e1:SetType(0x81)
	e1:SetCode(1100)
	e1:SetProperty(0x14000)
	e1:SetCountLimit(1,75646304)
	e1:SetTarget(c75646304.target)
	e1:SetOperation(c75646304.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(1102)
	c:RegisterEffect(e3)
	--tohand2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0xc)
	e2:SetType(0x40)
	e2:SetRange(0x4)
	e2:SetCountLimit(1,75646304)
	e2:SetTarget(c75646304.target1)
	e2:SetOperation(c75646304.operation1)
	c:RegisterEffect(e2)
end
function c75646304.filter(c)
	return c:IsSetCard(0x32c3) and c:IsType(0x1) and not c:IsCode(75646304) and c:IsAbleToHand()
end
function c75646304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646304.filter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x01)
end
function c75646304.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646304.filter,tp,0x01,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646304.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) 
		and c:IsAbleToRemove()
end
function c75646304.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646304.filter,tp,0x10,0,1,nil)
	and Duel.IsExistingMatchingCard(c75646304.rfilter,tp,0x0c,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x10)
end
function c75646304.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646304.filter,tp,0x10,0,1,1,nil)
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Hint(3,tp,503)
		local g=Duel.SelectMatchingCard(tp,c75646304.rfilter,tp,0x0c,0,1,1,nil)
		Duel.Remove(g,0x5,0x40)
	end
end