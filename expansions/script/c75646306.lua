--普通线圈
function c75646306.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x0010)
	e2:SetCode(1002)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x4+CATEGORY_COIN)
	e1:SetType(0x201)
	e1:SetProperty(0x14000)
	e1:SetCode(1011)
	e1:SetCondition(c75646306.con)
	e1:SetTarget(c75646306.cointg)
	e1:SetOperation(c75646306.op)
	c:RegisterEffect(e1)
	--grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(0x200)
	e3:SetType(0x0040)
	e3:SetRange(0x08)
	e3:SetCountLimit(1,75646306)
	e3:SetCost(c75646306.cost)
	e3:SetTarget(c75646306.target)
	e3:SetOperation(c75646306.operation)
	c:RegisterEffect(e3)
end
function c75646306.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(0x5) and e:GetHandler():IsPreviousLocation(0x08)
end
function c75646306.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c75646306.op(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.Hint(3,tp,503)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,0xc,1,1,nil)
	if tc then
		Duel.Remove(tc,0x5,0x40)
	end
	else Duel.Hint(3,tp,503)
	local tc=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0xc,0,1,1,nil)
	if tc then
		Duel.Remove(tc,0x5,0x40)
	end end
end
function c75646306.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),0x80)
end
function c75646306.filter(c,e,sp)
	return c:IsSetCard(0x32c3) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c75646306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(c75646306.filter,tp,0x02,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x02)
end
function c75646306.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c75646306.filter,tp,0x02,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,0x5)
	end
end