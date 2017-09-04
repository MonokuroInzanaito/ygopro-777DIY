--赤帽的搜寻者
function c400005.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c400005.target)
	e1:SetOperation(c400005.activate)
	c:RegisterEffect(e1)
end
function c400005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x420) and not c:IsType(TYPE_TUNER)
end
function c400005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c400005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c400005.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c400005.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c400005.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c400005.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		--to hand
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(400005,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetCondition(c400005.sumcon)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2) 
	end
end
function c400005.sumcon(e)
	local c=e:GetHandler()
	return not c:IsDisabled()
end