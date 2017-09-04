--少女骑士团 伏见翼
function c18755509.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,18755509)
	e2:SetTarget(c18755509.target)
	e2:SetOperation(c18755509.activate)
	c:RegisterEffect(e2)
	--sync
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40348946,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c18755509.con1)
	e3:SetOperation(c18755509.op1)
	c:RegisterEffect(e3)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40348946,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c18755509.con2)
	e4:SetOperation(c18755509.op2)
	c:RegisterEffect(e4)
end
function c18755509.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5abb) and not c:IsType(TYPE_TUNER)
end
function c18755509.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18755509.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18755509.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18755509.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18755509.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c18755509.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		--to hand
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(18755509,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetCondition(c18755509.sumcon)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5abb))
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2) 
	end
end
function c18755509.sumcon(e)
	local c=e:GetHandler()
	return not c:IsDisabled()
end
function c18755509.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0xabb)
end
function c18755509.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(18755509,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTarget(c18755509.atktg)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755509,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c18755509.atcon)
	e2:SetOperation(c18755509.atop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e2)
end
function c18755509.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0xabb)
end
function c18755509.atktg(e,c)
	return c:IsSetCard(0x5abb)
end
function c18755509.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c18755509.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c18755509.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xyz=c:GetReasonCard()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(18755509,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTarget(c18755509.atktg)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755509,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c18755509.atcon)
	e2:SetOperation(c18755509.atop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e2)
end