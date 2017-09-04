--Prima-Stella
function c75646112.initial_effect(c)
	c:EnableCounterPermit(0x4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x10)
	e1:SetCode(1002)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x2+0x800)
	e2:SetCode(1111)
	e2:SetRange(0x100)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c75646112.ctcon)
	e2:SetOperation(c75646112.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x2)
	e3:SetCode(100)
	e3:SetRange(0x100)
	e3:SetTargetRange(0x4,0x4)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x62c3))
	e3:SetValue(c75646112.atkval)
	c:RegisterEffect(e3)
	--special summon1
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(0x200)
	e3:SetDescription(aux.Stringid(75646112,0))
	e3:SetType(0x40)
	e3:SetRange(0x100)
	e3:SetCost(c75646112.cost)
	e3:SetTarget(c75646112.tg)
	e3:SetOperation(c75646112.op)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(75646112,1))
	e4:SetType(0x40)
	e4:SetRange(0x100)
	e4:SetCost(c75646112.cost2)
	e4:SetTarget(c75646112.tg2)
	e4:SetOperation(c75646112.op2)
	c:RegisterEffect(e4)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646112,2))
	e1:SetType(0x40)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetRange(0x100)
	e1:SetProperty(0x800)
	e1:SetCost(c75646112.cost3)
	e1:SetTarget(c75646112.damtg)
	e1:SetOperation(c75646112.damop)
	c:RegisterEffect(e1)
end
function c75646112.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,0x40)~=0 and re and re:GetHandler():IsSetCard(0x62c3) and re:GetHandler()~=e:GetHandler()
end
function c75646112.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4,1)
end
function c75646112.atkval(e,c)
	return e:GetHandler():GetCounter(0x4)*100
end
function c75646112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x4,7,0x80) end
	Duel.Hint(4,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x4,7,0x80)
end
function c75646112.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x4,5,0x80) end
	Duel.Hint(4,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x4,5,0x80)
end
function c75646112.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x4,3,0x80) end
	Duel.Hint(4,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x4,3,0x80)
end
function c75646112.filter(c,e,tp)
	return c:IsSetCard(0x62c3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(0x10) or c:IsFaceup())
end

function c75646112.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646112.filter,tp,0x30,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,0x200,nil,1,tp,0x30)
end

function c75646112.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	Duel.Hint(3,tp,509)
	local g=Duel.SelectMatchingCard(tp,c75646112.filter,tp,0x30,0,1,1,nil,e,tp)
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,0x5)~=0 and tc:GetLevel()~=4 then
		--xyzlv
		local e1=Effect.CreateEffect(c)
		e1:SetType(0x1)
		e1:SetCode(242)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(0x4)
		e1:SetValue(c75646112.xyzlv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		--special xyz rule
		local e2=Effect.CreateEffect(c)
		e2:SetType(0x1)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(75646112)
		e2:SetRange(0x4)
		e2:SetProperty(0x400+EFFECT_FLAG_UNCOPYABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
	end
end
function c75646112.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end
function c75646112.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75646112.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,0x80,0x100)
	Duel.Draw(p,d,0x40)
end
function c75646112.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646112.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,0x80,0x100)
	Duel.Damage(p,d,0x40)
end