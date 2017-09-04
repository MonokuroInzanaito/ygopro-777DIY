--Stella-星灵
function c75646118.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x2)
	e1:SetCode(34)
	e1:SetProperty(0x40000)
	e1:SetRange(0x2)
	e1:SetCountLimit(1,75646118)
	e1:SetCondition(c75646118.spcon)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646118,1))
	e3:SetCategory(0x80008)
	e3:SetType(0x40)
	e3:SetRange(0x2)
	e3:SetProperty(0x10)
	e3:SetCountLimit(1,7564618)
	e3:SetCost(c75646118.cost)
	e3:SetTarget(c75646118.tg)
	e3:SetOperation(c75646118.op)
	c:RegisterEffect(e3)
end
function c75646118.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x62c3) 
end
function c75646118.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),0x4)>0 and
		Duel.IsExistingMatchingCard(c75646118.filter1,c:GetControler(),0x4,0,1,nil)
end
function c75646118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable()end
	Duel.SendtoGrave(c,0x4080)
end
function c75646118.filter2(c)
	return c:IsSetCard(0x62c3) and c:IsAbleToHand() and not c:IsCode(75646118)
end
function c75646118.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646118.filter2,tp,0x10,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x10)
	Duel.SetOperationInfo(0,0x80000,nil,0,1-tp,100)
end
function c75646118.op(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(3,tp,506)
	local sg=Duel.SelectMatchingCard(tp,c75646118.filter2,tp,0x10,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,0x40)
		Duel.ConfirmCards(1-tp,sg)
		if Duel.Damage(1-tp,100,0x40)~=0 then
		local c=e:GetHandler()
		Duel.RaiseEvent(c,0x10000000+75646112,e,0,tp,0,0)
		end
	end   
end