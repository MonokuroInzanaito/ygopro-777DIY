--Stella-星屑
function c75646122.initial_effect(c)
	--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x10080001)
	e1:SetProperty(0xc0000)
	e1:SetType(0x10)
	e1:SetCode(1027)
	e1:SetCondition(c75646122.condition)
	e1:SetCountLimit(1,75646122+0x10000000)
	e1:SetTarget(c75646122.target)
	e1:SetOperation(c75646122.activate)
	c:RegisterEffect(e1)
end
function c75646122.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62c3) 
		and c:IsType(0x1)
end
function c75646122.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c75646122.cfilter,tp,0x4,0,1,nil)
end
function c75646122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,0x10000000,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,1,eg,1,0,0)
	end
end
function c75646122.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,0x40)~=0 and rc:IsType(0x1) then
	local atk=rc:GetBaseAttack()
		if atk<0 then atk=0 end
		if Duel.Damage(1-tp,atk,0x40)~=0 then
		Duel.RaiseEvent(e:GetHandler(),0x10000000+75646112,e,0,tp,0,0)
		end
	end
end