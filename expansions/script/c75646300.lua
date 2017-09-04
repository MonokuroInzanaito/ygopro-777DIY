--真渊京马
function c75646300.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646300,0))
	e1:SetCategory(0x20008)
	e1:SetType(0x81)
	e1:SetCode(1100)
	e1:SetProperty(0x14000)
	e1:SetCountLimit(1,75646300)
	e1:SetTarget(c75646300.target)
	e1:SetOperation(c75646300.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(1102)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646300,1))
	e3:SetProperty(0x0010)
	e3:SetCategory(0x5)
	e3:SetType(0x0040)
	e3:SetRange(0x4)
	e3:SetCountLimit(1,75646300)
	e3:SetTarget(c75646300.destg)
	e3:SetOperation(c75646300.desop)
	c:RegisterEffect(e3)
end
function c75646300.filter(c)
	return c:IsSetCard(0x52c3) and c:IsAbleToHand() and (c:IsLocation(0x10) or c:IsFaceup())
end
function c75646300.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646300.filter,tp,0x21,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x21)
end
function c75646300.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646300.filter,tp,0x21,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646300.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) 
		and c:IsAbleToRemove()
end
function c75646300.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,0xc,1,nil) 
	and Duel.IsExistingMatchingCard(c75646300.rfilter,tp,0xc,0,1,nil,e,tp) end
	Duel.Hint(3,tp,502)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,0xc,1,1,nil)
	Duel.SetOperationInfo(0,0x1,g,1,0,0)
end
function c75646300.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,0x40)
		Duel.BreakEffect()
		Duel.Hint(3,tp,503)
		local g=Duel.SelectMatchingCard(tp,c75646300.rfilter,tp,0xc,0,1,1,nil)
		Duel.Remove(g,0x5,0x40)
	end
end