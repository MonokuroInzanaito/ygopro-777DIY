--NUMBERS线圈
function c75646307.initial_effect(c)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(0x0010)
	e4:SetCode(1002)
	c:RegisterEffect(e4)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x2)
	e2:SetRange(0x100)
	e2:SetCode(29)
	e2:SetTargetRange(0x6,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x32c3))
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x4+CATEGORY_COIN)
	e1:SetType(0x201)
	e1:SetProperty(0x14000)
	e1:SetCode(1011)
	e1:SetCondition(c75646307.con)
	e1:SetTarget(c75646307.cointg)
	e1:SetOperation(c75646307.op)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(0x200000)
	e3:SetType(0x202)
	e3:SetRange(0x08)
	e3:SetCountLimit(1)
	e3:SetCode(0x1200)
	e3:SetTarget(c75646307.atktg)
	e3:SetOperation(c75646307.atkop)
	c:RegisterEffect(e3)
end

function c75646307.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(0x5) and e:GetHandler():IsPreviousLocation(0x08)
end
function c75646307.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c75646307.op(e,tp,eg,ep,ev,re,r,rp)
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
function c75646307.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75646307.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c3)
end
function c75646307.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c75646307.filter,tp,0x04,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(0x0001)
		e1:SetCode(100)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c75646307.filter1(c)
	return c:IsSetCard(0x32c3) and c:IsSummonable(true,nil)
end
function c75646307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and Duel.IsExistingMatchingCard(c75646307.filter1,tp,0x2,0,1,nil) end
	Duel.SetOperationInfo(0,0x100,nil,1,0,0)
end
function c75646307.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(3,tp,508)
	local g=Duel.SelectMatchingCard(tp,c75646307.filter1,tp,0x2,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end