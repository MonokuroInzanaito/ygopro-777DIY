--镜空间
function c11111049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111049,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11111049.discon)
	e2:SetCost(c11111049.discost)
	e2:SetTarget(c11111049.distg)
	e2:SetOperation(c11111049.disop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c11111049.destg)
	e3:SetValue(c11111049.value)
	e3:SetOperation(c11111049.desop)
	c:RegisterEffect(e3)
end
function c11111049.tfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x15d) and c:IsType(TYPE_XYZ)
end
function c11111049.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c11111049.tfilter,1,nil) and Duel.IsChainNegatable(ev)
end	
function c11111049.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c11111049.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11111049.disop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
end
function c11111049.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x15d) and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c11111049.repfilter(c)
	return c:IsSetCard(0x15d) and c:IsAbleToRemove()
end
function c11111049.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	    local count=eg:FilterCount(c11111049.dfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and Duel.IsExistingMatchingCard(c11111049.repfilter,tp,LOCATION_GRAVE,0,count,nil)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(11111049,1))
end
function c11111049.value(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x15d) and c:IsType(TYPE_XYZ) and c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_EFFECT)
end
function c11111049.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111049.repfilter,tp,LOCATION_GRAVE,0,count,count,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end