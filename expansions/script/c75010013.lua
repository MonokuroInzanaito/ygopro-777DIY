--战术人形行动·魔方行动
function c75010013.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010013)
	e1:SetCondition(c75010013.condition)
	e1:SetOperation(c75010013.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75010013,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75011013)
	e2:SetCost(c75010013.dmcost)
	e2:SetCondition(c75010013.dmcon)
	e2:SetTarget(c75010013.dmtg)
	e2:SetOperation(c75010013.dmop)
	c:RegisterEffect(e2)
end
function c75010013.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x520) and c:IsType(TYPE_MONSTER)
end
function c75010013.condition(e)
	return Duel.IsExistingMatchingCard(c75010013.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c75010013.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c75010013.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75010013.negfilter,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local g=Group.CreateGroup()
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsCanAddCounter(0x520,1) and tc:IsSetCard(0x520) then
			tc:AddCounter(0x520,1)
		end
	end
end
function c75010013.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c75010013.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil and Duel.GetAttacker():IsSetCard(0x520)
end
function c75010013.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c75010013.dmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct~=0 then
		Duel.Damage(1-tp,300*ct,REASON_EFFECT)
	end
end