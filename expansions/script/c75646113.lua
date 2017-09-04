--Stella-星愿
function c75646113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x80200)
	e1:SetType(0x10)
	e1:SetCode(1002)
	e1:SetProperty(0x10)
	e1:SetCountLimit(1,75646113+0x10000000)
	e1:SetTarget(c75646113.target)
	e1:SetOperation(c75646113.activate)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646113,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(0x40)
	e2:SetRange(0x10)
	e2:SetProperty(0x800)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c75646113.damcost)
	e2:SetTarget(c75646113.damtg)
	e2:SetOperation(c75646113.damop)
	c:RegisterEffect(e2)
end
function c75646113.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,0x80)
end
function c75646113.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646113.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,0x80,0x100)
	Duel.Damage(p,d,0x40)
end
function c75646113.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsType(0x1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646113.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x10) and c75646113.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingTarget(c75646113.filter,tp,0x10,0,1,nil,e,tp) end
	Duel.Hint(3,tp,509)
	local g=Duel.SelectTarget(tp,c75646113.filter,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,0x200,g,1,0,0)
end
function c75646113.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)
	end   
end