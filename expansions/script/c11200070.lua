--借符「大穴牟迟大人的药」
function c11200070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,11200070+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11200070.condition)
	e1:SetOperation(c11200070.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c11200070.handcon)
	c:RegisterEffect(e2)	
end
function c11200070.handcon(e)
	return Duel.IsExistingMatchingCard(c11200070.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c11200070.cfilter(c)
	return c:IsSetCard(0xffee) and c:IsType(TYPE_MONSTER)
end
function c11200070.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xffee) and rp==tp
end
function c11200070.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(0xff,0)
	e1:SetValue(c11200070.efilter)
	e1:SetTarget(c11200070.etarget)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c11200070.etarget(e,c)
	return c:IsSetCard(0xffee)
end
function c11200070.efilter(e,re)
	return re:IsHasType(EFFECT_TYPE_ACTIONS)
end
