--Stella-星坠
function c75646114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646114,0))  
	e1:SetCategory(0x200)
	e1:SetType(0x10)
	e1:SetCode(1002)
	e1:SetCountLimit(1,75646114+0x10000000)
	e1:SetCondition(c75646114.condition)
	e1:SetTarget(c75646114.target)
	e1:SetOperation(c75646114.activate)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646114,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(0x40)
	e2:SetRange(0x10)
	e2:SetProperty(0x800)
	e2:SetCost(c75646114.damcost)
	e2:SetTarget(c75646114.damtg)
	e2:SetOperation(c75646114.damop)
	c:RegisterEffect(e2)
end
	function c75646114.cfilter(c)
	return c:IsSetCard(0x62c3) and c:IsAbleToRemoveAsCost()
end
function c75646114.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c75646114.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646114.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,0x5,0x80)
end
function c75646114.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c75646114.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,0x80,0x100)
	Duel.Damage(p,d,0x40)
end
function c75646114.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0x4,0,1,nil)
end
function c75646114.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsType(0x1) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646114.filter,tp,0x1,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x1)
end
function c75646114.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x4)<=0 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646114.filter,tp,0x1,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,0x5)
	end 
end
