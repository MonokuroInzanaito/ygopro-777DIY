--新特斯拉能源
function c75646310.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x10)
	e1:SetCode(1002)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x0002)
	e2:SetProperty(0x20000)
	e2:SetRange(0x100)
	e2:SetTargetRange(0x04,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x32c3))
	e2:SetCode(100)
	e2:SetValue(c75646310.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(104)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(0x8+0x20000)
	e4:SetType(0x81)
	e4:SetCode(1014)
	e4:SetProperty(0x10000)
	e4:SetCountLimit(1,75646310)
	e4:SetCondition(c75646310.thcon)
	e4:SetTarget(c75646310.thtg)
	e4:SetOperation(c75646310.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(1011)
	c:RegisterEffect(e5)
end
function c75646310.filter(c)
	return c:IsCode(75646306) and c:IsAbleToHand()
end
function c75646310.activate(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c75646310.filter,tp,0x01,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646310,0)) then
		Duel.Hint(3,tp,506)
		local g=Duel.SelectMatchingCard(tp,c75646310.filter,tp,0x01,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,0x40)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c75646310.cfilter(c)
	return c:IsFaceup() and c:IsCode(75646306)
end
function c75646310.value(e,c)
	return Duel.GetMatchingGroupCount(c75646310.cfilter,tp,0x0c,0x0c,nil)*400
end
function c75646310.thfilter(c)
	return c:IsSetCard(0x32c3) and c:IsAbleToHand()
end
function c75646310.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(0x08) and c:GetPreviousSequence()==5 and c:IsPreviousPosition(0x5)
end
function c75646310.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646310.thfilter,tp,0x11,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x11)
end
function c75646310.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646310.thfilter,tp,0x11,0,1,1,nil)
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end