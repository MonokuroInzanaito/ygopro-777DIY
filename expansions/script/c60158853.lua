--赤红骑士之歌
function c60158853.initial_effect(c)
	c:SetUniqueOnField(1,0,60158853)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c60158853.con)
	e2:SetCost(c60158853.cost)
	e2:SetOperation(c60158853.op)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158853,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60158853.condition)
	e3:SetCost(c60158853.cost2)
	e3:SetTarget(c60158853.target)
	e3:SetOperation(c60158853.operation)
	c:RegisterEffect(e3)
	if c60158853.counter==nil then
		c60158853.counter=true
		c60158853[0]=0
		c60158853[1]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c60158853.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_TO_GRAVE)
		e5:SetOperation(c60158853.addcount)
		Duel.RegisterEffect(e5,0)
	end
end
function c60158853.con(e,tp,eg,ep,ev,re,r,rp)
	return c60158853[tp]>0 
end
function c60158853.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60158853)==0 end
	Duel.RegisterFlagEffect(tp,60158853,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60158853.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c60158853.etarget)
	e2:SetValue(c60158853.efilter)
	Duel.RegisterEffect(e2,tp)
end
function c60158853.etarget(e,c)
	return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c60158853.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60158853.filter(c)
	return c:IsSetCard(0x5b28) and c:IsOnField() and c:IsFaceup()
end
function c60158853.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c60158853.filter,nil)-tg:GetCount()>0
end
function c60158853.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60158853.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c60158853.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c60158853.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c60158853[0]=0
	c60158853[1]=0
end
function c60158853.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_COST) and re:IsHasType(0x7f0) and tc:IsControler(tp) and tc:IsSetCard(0x5b28) then
			local p=tp
			if c60158853[p]<1 then
				c60158853[p]=c60158853[p]+1
			end
		end
		tc=eg:GetNext()
	end
end