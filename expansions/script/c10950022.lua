--毕业祝词
function c10950022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10950022.condition)
	e1:SetOperation(c10950022.addc)
	c:RegisterEffect(e1)	
end
function c10950022.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c10950022.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10950022.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10950022.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c10950022.addc(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10950022.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do 
		tc:AddCounter(0x13ac,2)
		tc=g:GetNext()
	end
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x231))
	e1:SetValue(c10950022.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10950022.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
