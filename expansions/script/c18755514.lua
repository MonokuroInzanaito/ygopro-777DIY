--少女骑士团 千代田麻里
function c18755514.initial_effect(c)
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
	e2:SetCountLimit(1,18755514)
	e2:SetTarget(c18755514.target)
	e2:SetOperation(c18755514.activate)
	c:RegisterEffect(e2)
	--sync
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40348946,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c18755514.con1)
	e3:SetOperation(c18755514.op1)
	c:RegisterEffect(e3)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40348946,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c18755514.con2)
	e4:SetOperation(c18755514.op2)
	c:RegisterEffect(e4)
end
function c18755514.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5abb) and not c:IsType(TYPE_TUNER)
end
function c18755514.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18755514.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18755514.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18755514.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18755514.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c18755514.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		--to hand
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TOHAND)
		e2:SetDescription(aux.Stringid(18755514,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCost(c18755514.costa)
		e2:SetTarget(c18755514.ptg)
		e2:SetOperation(c18755514.pop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2) 
	end
end
function c18755514.costa(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18755514.lfilter(c,e,tp,b1)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsSetCard(0x5abb)
		and (b1 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c18755514.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(c18755514.lfilter,tp,LOCATION_DECK,0,1,nil,e,tp,b1) end
end
function c18755514.pop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not b1 and not b2 then return end
	local g=Duel.GetMatchingGroup(c18755514.lfilter,tp,LOCATION_DECK,0,nil,e,tp,b1)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g:Select(tp,1,1,nil)
	Duel.ShuffleDeck(tp)
	local tc=sg1:GetFirst()
	if b1 and (not b2 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectYesNo(tp,aux.Stringid(14733538,0))) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18755514.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0xabb)
end
function c18755514.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(18755514,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c18755514.aclimit)
	e1:SetCondition(c18755514.actcon)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755514,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c18755514.dircon)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e2)
end
function c18755514.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c18755514.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5abb) and c:IsControler(tp)
end
function c18755514.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c18755514.cfilter(a,tp)) or (d and c18755514.cfilter(d,tp))
end
function c18755514.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0xabb)
end
function c18755514.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xyz=c:GetReasonCard()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(18755514,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c18755514.aclimit)
	e1:SetCondition(c18755514.actcon)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755514,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c18755514.dircon)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e2)
end
function c18755514.ccfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c18755514.dircon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18755514.ccfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
end