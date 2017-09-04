--Stella-星彩
function c75646125.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x200+CATEGORY_DAMAGE)
	e1:SetType(0x82)
	e1:SetCode(1111)
	e1:SetRange(0x2)
	e1:SetCondition(c75646125.ctcon)
	e1:SetProperty(0x14000)
	e1:SetTarget(c75646125.tg)
	e1:SetOperation(c75646125.op)
	c:RegisterEffect(e1)
	--special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x200+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(75646125,1))
	e2:SetType(0x40)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,75646125)
	e2:SetCost(c75646125.spcost)
	e2:SetTarget(c75646125.sptarget)
	e2:SetOperation(c75646125.spoperation)
	c:RegisterEffect(e2)
end
function c75646125.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re and re:GetHandler():IsSetCard(0x62c3) and bit.band(r,0x40)~=0
end
function c75646125.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,0x200,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646125.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,0x5)==0 and Duel.GetLocationCount(tp,0x4)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,0x400)
	else if Duel.Damage(1-tp,100,0x40)~=0 then 
		Duel.RaiseEvent(c,0x10000000+75646112,e,0,tp,0,0)
	end end   
end
function c75646125.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsType(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646125.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,0x80)
end
function c75646125.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646125.filter,tp,0x12,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x12)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646125.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x4)<=0 then return end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646125.filter,tp,0x12,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,0x5) then
			Duel.Damage(1-tp,100,0x40) end end
end