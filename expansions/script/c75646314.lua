--Grendel 真渊京马
function c75646314.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x32c3),4,2)
	c:EnableReviveLimit()
	--rmove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x4)
	e1:SetType(0x0040)
	e1:SetCode(1002)
	e1:SetRange(0x04)
	e1:SetCountLimit(1)
	e1:SetCost(c75646314.cost)
	e1:SetTarget(c75646314.tg)
	e1:SetOperation(c75646314.op)
	c:RegisterEffect(e1)
	--specialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x200)
	e2:SetType(0x81)
	e2:SetCode(1014)
	e2:SetProperty(0x4000+0x10000)
	e2:SetCondition(c75646314.spcon)
	e2:SetCountLimit(1,75646314)
	e2:SetTarget(c75646314.sptg)
	e2:SetOperation(c75646314.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(1011)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(1013)
	c:RegisterEffect(e4)
end
function c75646314.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end
function c75646314.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x0c,0x0c,1,nil) 
	and Duel.IsExistingMatchingCard(c75646314.rfilter,tp,0x0c,0,1,nil,e,tp) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x0c,0x0c,nil)
	Duel.SetOperationInfo(0,0x4,sg,1,0,0)
end
function c75646314.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3) and c:IsAbleToRemove()
end
function c75646314.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x0c,0x0c,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(3,tp,503)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,0x5,0x40)
		Duel.BreakEffect()
		Duel.Hint(3,tp,503)
		local g=Duel.SelectMatchingCard(tp,c75646314.rfilter,tp,0x0c,0,1,1,nil)
		Duel.Remove(g,0x5,0x40)
	end
end
function c75646314.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(0x5) and e:GetHandler():IsPreviousLocation(0x0c)
end
function c75646314.filter(c,e,tp)
	return c:IsSetCard(0x32c3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646314.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(c75646314.filter,tp,0x01,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x01)
end
function c75646314.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646314.filter,tp,0x01,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,0x5)
	end
end
