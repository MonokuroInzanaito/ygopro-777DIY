--忧面「杞人忧地」
function c19301009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c19301009.rmcon)
	e1:SetTarget(c19301009.target)
	e1:SetOperation(c19301009.operation)
	c:RegisterEffect(e1)
end
function c19301009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c19301009.thfilter(c)
	return c:IsSetCard(0x190) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c19301009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19301009.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19301009.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c19301009.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c19301009.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT))
end
function c19301009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) and tg:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tg,POS_FACEUP_DEFENCE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c19301009.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	tg:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c19301009.filter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c19301009.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end