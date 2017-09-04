--6th-下一个是谁呢？
function c66600618.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600618,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c66600618.con)
	e1:SetTarget(c66600618.tg)
	e1:SetOperation(c66600618.op)
	c:RegisterEffect(e1)
	 --destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c66600618.destg)
	e2:SetValue(c66600618.value)
	e2:SetOperation(c66600618.desop)
	c:RegisterEffect(e2)
 --
	 local e5=Effect.CreateEffect(c)
	e5:SetRange(LOCATION_SZONE)
   e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e5:SetCode(EVENT_CHAINING)
   e5:SetCondition(c66600618.flcon)
	e5:SetOperation(c66600618.flop)
	c:RegisterEffect(e5)
end
function c66600618.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x66e)
end
function c66600618.con(e,tp,eg,ep,ev,re,r,rp)
  return  e:GetHandler():GetFlagEffect(66600618)>0 
end
function c66600618.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66600618.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	 Duel.Draw(p,d,REASON_EFFECT)
end
function c66600618.dfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and
	c:IsSetCard(0x66e) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end
function c66600618.repfilter(c)
	return c:IsSetCard(0x66e) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66600618.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c66600618.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c66600618.repfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(66600618,1))
end
function c66600618.value(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x66e) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end
function c66600618.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66600618.repfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c66600618.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
   if not g  then return false end
  return g:IsExists(c66600618.tgfilter,1,nil,tp)
end
function c66600618.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600618,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end