--黄昏视界
function c10981088.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10981088.activate)
	c:RegisterEffect(e1)	
end
function c10981088.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c10981088.target)
	Duel.RegisterEffect(e1,tp)
end
function c10981088.target(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
