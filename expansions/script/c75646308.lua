--Genesis
function c75646308.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x200000)
	e2:SetType(0x10)
	e2:SetCode(1002)
	e2:SetCost(c75646308.cost)
	e2:SetTarget(c75646308.target)
	e2:SetOperation(c75646308.activate)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646308,0))
	e1:SetCategory(0x200)
	e1:SetType(0x40)
	e1:SetRange(0x8)
	e1:SetCountLimit(1)
	e1:SetTarget(c75646308.sptg)
	e1:SetOperation(c75646308.spop)
	c:RegisterEffect(e1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x2)
	e3:SetCode(71)
	e3:SetRange(0x8)
	e3:SetTargetRange(0xc,0)
	e3:SetTarget(c75646308.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3) 
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(0x2)
	e4:SetCode(41)
	e4:SetRange(0x8)
	e4:SetTargetRange(0xc,0)
	e4:SetValue(c75646308.indval)
	e4:SetTarget(c75646308.tgtg)
	c:RegisterEffect(e4)
end
function c75646308.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) 
		and not c:IsCode(75646308)
		and c:IsAbleToGraveAsCost()
end
function c75646308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646308.costfilter,tp,0x0c,0,3,nil) end
	Duel.Hint(3,tp,504)
	local g=Duel.SelectMatchingCard(tp,c75646308.costfilter,tp,0x0c,0,3,3,nil)
	Duel.SendtoGrave(g,0x80)
end
function c75646308.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c3)
end
function c75646308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646308.afilter,tp,0x04,0,1,nil) end
end
function c75646308.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c75646308.afilter,tp,0x04,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(0x0001)
		e1:SetCode(100)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c75646308.filter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(0x11)) and c:IsSetCard(0x32c3) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646308.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646308.filter,tp,0x31,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x31)
end
function c75646308.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,0x4)<=0 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646308.filter,tp,0x31,0,1,1,nil,e,tp)
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,0x5)
	end
end
function c75646308.tgtg(e,c)
	return c:IsSetCard(0x52c3) and not c:IsCode(75646308)
end

function c75646308.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end