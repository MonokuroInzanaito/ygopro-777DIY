--英灵少女 斯卡哈
function c18700334.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44178886,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetTarget(c18700334.targ)
	e1:SetOperation(c18700334.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c18700334.aclimit)
	e3:SetCondition(c18700334.actcon)
	c:RegisterEffect(e3)
end
function c18700334.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and t:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function c18700334.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() then
		if not t:IsDisabled() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			t:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(t,RESET_TURN_SET)
			t:RegisterEffect(e2)
		end
		Duel.Destroy(t,REASON_EFFECT)
	end
end
function c18700334.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c18700334.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xabb) and c:IsControler(tp)
end
function c18700334.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c18700334.cfilter(a,tp)) or (d and c18700334.cfilter(d,tp))
end
