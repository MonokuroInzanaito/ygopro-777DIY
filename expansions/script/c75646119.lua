--Stella-星辰
function c75646119.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646119,1))
	e1:SetType(0x40)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetRange(0x4)
	e1:SetProperty(0x800)
	e1:SetCountLimit(1)
	e1:SetCode(1002)
	e1:SetTarget(c75646119.damtg)
	e1:SetOperation(c75646119.damop)
	c:RegisterEffect(e1)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75646119,0))
	e5:SetCategory(0x20008+CATEGORY_DAMAGE)
	e5:SetType(0x82)
	e5:SetRange(0x4)
	e5:SetCountLimit(1,75646119)
	e5:SetCode(1111)
	e5:SetCondition(c75646119.ctcon)
	e5:SetTarget(c75646119.thtg)
	e5:SetOperation(c75646119.thop)
	c:RegisterEffect(e5)
end
function c75646119.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646119.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,0x80,0x100)
	Duel.Damage(p,d,0x40)
end
function c75646119.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re and re:GetHandler():IsSetCard(0x62c3) and bit.band(r,0x40)~=0 and re:GetHandler()~=e:GetHandler()
end
function c75646119.thfilter(c)
	return c:IsSetCard(0x62c3) and c:IsAbleToHand()
end
function c75646119.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646119.thfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x1)
	Duel.SetOperationInfo(0,0x80000,nil,0,1-tp,100)
end
function c75646119.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646119.thfilter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
		Duel.Damage(1-tp,100,0x40)
	end   
end