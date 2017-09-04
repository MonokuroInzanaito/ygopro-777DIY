--为了我们的星辉！
function c66666623.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c66666623.condition)
	e1:SetTarget(c66666623.target)
	e1:SetOperation(c66666623.activate)
	c:RegisterEffect(e1)
end
function c66666623.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c66666623.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x661)
end
function c66666623.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c66666623.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666623.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666623.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66666623.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(2600)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
		--discard
	    local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetCategory(CATEGORY_REMOVE)
	    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	    e2:SetCode(EVENT_BATTLE_DAMAGE)
	    e2:SetCondition(c66666623.condition1)
	    e2:SetOperation(c66666623.operation)
		e2:SetReset(RESET_EVENT+0xfe0000)
	    tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c66666623.efilter)
		e3:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e3)
	end
end
function c66666623.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c66666623.condition1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c66666623.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
