--生命律动
function c60159021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c60159021.operation)
	c:RegisterEffect(e1)
end
function c60159021.operation(e,tp,eg,ep,ev,re,r,rp)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c60159021.tg)
	e1:SetValue(c60159021.efilter)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60159021.tg(e,c)
	return c:IsFaceup() and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159021.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end