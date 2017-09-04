--少女骑士团 伊薇
function c18755507.initial_effect(c)
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
	e2:SetCountLimit(1,18755507)
	e2:SetTarget(c18755507.target)
	e2:SetOperation(c18755507.activate)
	c:RegisterEffect(e2)
	--sync
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40348946,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c18755507.con1)
	e3:SetOperation(c18755507.op1)
	c:RegisterEffect(e3)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40348946,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c18755507.con2)
	e4:SetOperation(c18755507.op2)
	c:RegisterEffect(e4)
end
function c18755507.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5abb) and not c:IsType(TYPE_TUNER)
end
function c18755507.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18755507.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18755507.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18755507.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c18755507.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c18755507.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
		--destroy
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(18755507,0))
		e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c18755507.destg)
		e2:SetOperation(c18755507.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c18755507.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xabb)
end
function c18755507.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c18755507.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18755507.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18755507.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c18755507.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
	if tc:GetAttack()>0  then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
	end
end
function c18755507.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0xabb)
end
function c18755507.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18755507,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18755507.atkval)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e1)
	--cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755507,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c18755507.target1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	sync:RegisterEffect(e2)
	--inactivatable
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_FIELD)
	--e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetValue(c18755507.effectfilter)
	--e4:SetReset(RESET_EVENT+0x1fe0000)
	--sync:RegisterEffect(e4)
	--local e5=Effect.CreateEffect(c)
   -- e5:SetType(EFFECT_TYPE_FIELD)
   -- e5:SetCode(EFFECT_CANNOT_DISEFFECT)
   -- e5:SetRange(LOCATION_MZONE)
   -- e5:SetValue(c18755507.effectfilter)
   -- e5:SetReset(RESET_EVENT+0x1fe0000)
   -- sync:RegisterEffect(e5)
end
function c18755507.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x5abb)
end
function c18755507.target1(e,c)
	return c:IsSetCard(0x5abb)
end
function c18755507.atkval(e,c)
	local cont=c:GetControler()
	if Duel.GetLP(cont)-Duel.GetLP(1-cont)>0 then
	return Duel.GetLP(cont)-Duel.GetLP(1-cont)
	else
	return 0
	end
end
function c18755507.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0xabb)
end
function c18755507.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xyz=c:GetReasonCard()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18755507,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18755507.atkval)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e1)
	--cannot disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18755507,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c18755507.target1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e2)
	--inactivatable
   -- local e4=Effect.CreateEffect(c)
   -- e4:SetType(EFFECT_TYPE_FIELD)
   -- e4:SetCode(EFFECT_CANNOT_INACTIVATE)
   -- e4:SetRange(LOCATION_MZONE)
   -- e4:SetValue(c18755507.effectfilter)
   -- e4:SetReset(RESET_EVENT+0x1fe0000)
   -- xyz:RegisterEffect(e4)
   -- local e5=Effect.CreateEffect(c)
   -- e5:SetType(EFFECT_TYPE_FIELD)
   -- e5:SetCode(EFFECT_CANNOT_DISEFFECT)
   -- e5:SetRange(LOCATION_MZONE)
   -- e5:SetValue(c18755507.effectfilter)
   -- e5:SetReset(RESET_EVENT+0x1fe0000)
   -- xyz:RegisterEffect(e5)
end
function c18755507.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	local cont=e:GetHandler():GetControler()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and Duel.GetLP(cont)-Duel.GetLP(1-cont)>0
end
function c18755507.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local cont=e:GetHandler():GetControler()
	if Duel.GetLP(cont)-Duel.GetLP(1-cont)>0 then
	   Duel.Damage(1-cont,Duel.GetLP(cont)-Duel.GetLP(1-cont),REASON_EFFECT)
	end
end