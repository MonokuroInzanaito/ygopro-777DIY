--空间乱数挤压
function c21520040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21520040.cost)
	e1:SetTarget(c21520040.target)
	e1:SetOperation(c21520040.operation)
	c:RegisterEffect(e1)
	--immue
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c21520040.econ)
	e3:SetValue(c21520040.efilter)
	c:RegisterEffect(e3)
end
function c21520040.filter(c)
	return c:IsSetCard(0x493) and c:IsFaceup() and c:IsReleasable()
end
function c21520040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c21520040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c21520040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
	e:SetLabel(e:GetLabel())
end
function c21520040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=e:GetLabel()
	local ct2=e:GetLabel()
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(tp,LOCATION_SZONE))<ct1 then 
		ct1=(Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(tp,LOCATION_SZONE))
	end
	if (Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE))<ct2 then 
		ct2=(Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE))
	end
	local dis1=Duel.SelectDisableField(tp,ct1,LOCATION_MZONE+LOCATION_SZONE,0,0)
	local dis2=Duel.SelectDisableField(tp,ct2,0,LOCATION_MZONE+LOCATION_SZONE,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c21520040.disableop)
	e1:SetLabel(dis1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(dis2)
	c:RegisterEffect(e2)
end
function c21520040.disableop(e,tp)
	return e:GetLabel()
end
function c21520040.rfilter(c)
	return c:IsSetCard(0x5493) and c:IsFaceup()
end
function c21520040.econ(e)
	local ct=Group.GetClassCount(Duel.GetMatchingGroup(c21520040.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil),Card.GetOriginalCode)
	return ct>=8
end
function c21520040.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
