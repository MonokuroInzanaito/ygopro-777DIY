--操鸟术 越冬
function c18702323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,18702323)
	e1:SetTarget(c18702323.target)
	e1:SetOperation(c18702323.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c18702323.checkop)
	c:RegisterEffect(e2)
	--Revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44508094,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c18702323.sumcon)
	e2:SetOperation(c18702323.sumop)
	c:RegisterEffect(e2)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c18702323.tg)
	c:RegisterEffect(e2)
end
function c18702323.tg(e,c)
	return c:IsSetCard(0x298)
end
function c18702323.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ab2)
end
function c18702323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c18702323.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18702323.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c18702323.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18702323.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c18702323.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetCondition(c18702323.rcon)
		e3:SetValue(c18702323.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
	e:GetHandler():RegisterFlagEffect(18702323,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c18702323.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetOwner():GetFlagEffect(18702323)~=0
end
function c18702323.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c18702323.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c18702323.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c18702323.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetFirstCardTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE)
	 and c:GetFlagEffect(18702323)>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c18702323.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end