--LOSER
function c75646302.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646302,0))
	e1:SetCategory(0x20008)
	e1:SetType(0x81)
	e1:SetCode(1100)
	e1:SetProperty(0x14000)
	e1:SetTarget(c75646302.target)
	e1:SetOperation(c75646302.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(1102)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646302,1))
	e3:SetCategory(0x4)
	e3:SetType(0x0040)
	e3:SetRange(0x04)
	e3:SetCountLimit(1)
	e3:SetCondition(c75646302.recon)
	e3:SetTarget(c75646302.retg)
	e3:SetOperation(c75646302.resop)
	c:RegisterEffect(e3)
	--base attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(0x0001)
	e4:SetCode(103)
	e4:SetProperty(0x20000)
	e4:SetRange(0x04)
	e4:SetValue(c75646302.atkval)
	c:RegisterEffect(e4)
end
function c75646302.filter(c)
	return c:IsCode(75646307) and c:IsAbleToHand()
end
function c75646302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646302.filter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x01)
end
function c75646302.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646302.filter,tp,0x01,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646302.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3)
end
function c75646302.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75646302.cfilter,tp,0x0c,0,5,nil)
end
function c75646302.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,0x4,nil,1,0,0)
end
function c75646302.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) and c:IsAbleToRemove()
end
function c75646302.resop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,e:GetHandler()) then return end
		Duel.Hint(3,tp,503)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,e:GetHandler())
		Duel.Remove(sg,0x5,0x400)
		Duel.BreakEffect()
		Duel.Hint(3,tp,503)
		local g=Duel.SelectMatchingCard(tp,c75646302.rfilter,tp,0x0c,0,1,1,nil)
		Duel.Remove(g,0x5,0x40)
end
function c75646302.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3)
end
function c75646302.atkval(e,c)
	return Duel.GetMatchingGroupCount(c75646302.atkfilter,c:GetControler(),0x0c,0,nil)*700
end