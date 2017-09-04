--黑化 丈枪由纪
function c75646026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,4),4,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x40)
	e1:SetProperty(0x10)
	e1:SetCountLimit(1,7564626)
	e1:SetRange(0x4)
	e1:SetCost(c75646026.cost)
	e1:SetTarget(c75646026.target)
	e1:SetOperation(c75646026.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x20008)
	e2:SetType(0x81)
	e2:SetProperty(0x10000)
	e2:SetCode(1102)
	e2:SetTarget(c75646026.thtg)
	e2:SetCountLimit(1,75646026)
	e2:SetOperation(c75646026.thop)
	c:RegisterEffect(e2)
end
function c75646026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end
function c75646026.filter(c)
	return not (c:IsHasEffect(43) and c:IsHasEffect(44))
end
function c75646026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646026.filter,tp,0,4,1,nil) end
end
function c75646026.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,514)
	local g=Duel.SelectMatchingCard(tp,c75646026.filter,tp,0,0x4,1,1,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x1)
	e1:SetCode(153)
	e1:SetReset(0x1000+0x1fe0000+RESET_PHASE+0x200)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x1)
	e2:SetCode(101)
	e2:SetReset(0x1000+0xfe0000)
	e2:SetValue(1750)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(105)
	e3:SetValue(1350)
	tc:RegisterEffect(e3)
end
function c75646026.thfilter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsAbleToHand()
end
function c75646026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646026.thfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x1)
end
function c75646026.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646026.thfilter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end