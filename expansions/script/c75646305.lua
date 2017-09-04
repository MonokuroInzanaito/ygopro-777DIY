--路维王子
function c75646305.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x200)
	e1:SetType(0x81)
	e1:SetProperty(0x14000)
	e1:SetCode(1012)
	e1:SetCondition(c75646305.condition)
	e1:SetCost(c75646305.spcost)
	e1:SetTarget(c75646305.target)
	e1:SetOperation(c75646305.operation)
	c:RegisterEffect(e1)
	--specialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(0x200)
	e3:SetType(0x81)
	e3:SetCode(1014)
	e3:SetProperty(0x14000)
	e3:SetCondition(c75646305.spcon)
	e3:SetCountLimit(1,75646305)
	e3:SetTarget(c75646305.sptg)
	e3:SetOperation(c75646305.spop)
	c:RegisterEffect(e3)
end
function c75646305.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3)
end
function c75646305.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75646305)==0 end
	Duel.RegisterFlagEffect(tp,75646305,0x40000000+0x200,0,1)
end
function c75646305.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x40)~=0 and Duel.IsExistingMatchingCard(c75646305.cfilter,tp,0x0c,0,1,nil)
end
function c75646305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,0x04)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,0x200,e:GetHandler(),1,0,0)
end
function c75646305.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,0x5)
	end
end

function c75646305.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x52c3)
end
function c75646305.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(0x0c) and Duel.IsExistingMatchingCard(c75646305.cfilter1,tp,0x0c,0,1,nil)
end
function c75646305.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x01)
end
function c75646305.spfilter(c,e,tp)
	return c:IsCode(75646305) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646305.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c75646305.spfilter,tp,0x01,0,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)
	end
end