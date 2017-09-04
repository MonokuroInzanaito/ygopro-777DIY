--次元崩塌
function c75646311.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x2000C)
	e1:SetType(0x0010)
	e1:SetCode(1002)
	e1:SetCountLimit(1,75646311+0x10000000)
	e1:SetTarget(c75646311.target)
	e1:SetOperation(c75646311.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x0001)
	e2:SetCode(15)
	e2:SetCondition(c75646311.handcon)
	c:RegisterEffect(e2)
end
function c75646311.handfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c3)
end
function c75646311.handcon(e)
	return Duel.IsExistingMatchingCard(c75646311.handfilter,e:GetHandlerPlayer(),0x04,0,1,nil)
end
function c75646311.filter1(c)
	return c:IsSetCard(0x32c3) and c:IsAbleToHand()
end
function c75646311.filter2(c)
	return c:IsSetCard(0x52c3) and c:IsAbleToHand()
end
function c75646311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c75646311.filter1,tp,0x01,0,1,nil)
		and Duel.IsExistingTarget(c75646311.filter2,tp,0x01,0,1,nil) 
	and Duel.IsExistingMatchingCard(c75646311.rfilter,tp,0x0c,0,1,nil,e,tp) end
	Duel.Hint(3,tp,506)
	local g1=Duel.SelectTarget(tp,c75646311.filter1,tp,0x01,0,1,1,nil)
	Duel.Hint(3,tp,506)
	local g2=Duel.SelectTarget(tp,c75646311.filter2,tp,0x01,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,0x8,g1,2,0,0)
end

function c75646311.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) and c:IsAbleToRemove()
end
function c75646311.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,0x40)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,0x40)
		Duel.ConfirmCards(1-tp,sg)
		Duel.BreakEffect()
		Duel.Hint(3,tp,503)
		local g=Duel.SelectMatchingCard(tp,c75646311.rfilter,tp,0x0c,0,1,1,nil)
		Duel.Remove(g,0x5,0x40)
	end
end