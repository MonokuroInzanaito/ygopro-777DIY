--伊丽莎白·史密斯
function c75646303.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x2)
	e1:SetCode(34)
	e1:SetProperty(0x40000)
	e1:SetRange(0x2)
	e1:SetCondition(c75646303.spcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x20008)
	e2:SetType(0x81)
	e2:SetCode(1100)
	e2:SetProperty(0x14000)
	e2:SetTarget(c75646303.thtg)
	e2:SetOperation(c75646303.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(1101)
	c:RegisterEffect(e3)
end
function c75646303.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c3) 
end
function c75646303.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),0x4)>0 and
		Duel.IsExistingMatchingCard(c75646303.filter,c:GetControler(),0xc,0,1,nil)
end
function c75646303.thfilter(c)
	return c:IsSetCard(0x52c3) and c:IsAbleToHand()
end
function c75646303.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646303.thfilter,tp,0x11,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x11)
end
function c75646303.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646303.thfilter,tp,0x11,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end