--群星的黑月之镰
function c66666621.initial_effect(c)
	--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666621,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c66666621.condition)
	e1:SetTarget(c66666621.target)
	e1:SetOperation(c66666621.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,66666621)
	e2:SetCondition(c66666621.condition)
	e2:SetCost(c66666621.negcost)
	e2:SetCondition(c66666621.negcon)
	e2:SetTarget(c66666621.negtg)
	e2:SetOperation(c66666621.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666621,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c66666621.bscon)
	e3:SetTarget(c66666621.bstarget)
	e3:SetOperation(c66666621.bsactivate)
	c:RegisterEffect(e3)
end
function c66666621.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x664)
end
function c66666621.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c66666621.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66666621.costfilter(c)
	return c:IsSetCard(0x664) and c:IsAbleToRemoveAsCost()
end
function c66666621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c66666621.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.BreakEffect()
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c66666621.negcostfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x661) and c:IsAbleToGraveAsCost()
end
function c66666621.negcostfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x664) and c:IsAbleToGraveAsCost()
end
function c66666621.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c66666621.negcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c66666621.negcostfilter,1,1,REASON_COST)
end
function c66666621.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and rp~=tp and Duel.IsExistingMatchingCard(c66666621.negcostfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c66666621.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c66666621.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.BreakEffect()
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c66666621.bsfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x661)
end
function c66666621.bscon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c66666621.bsfilter,1,nil) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c66666621.bstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c66666621.bsactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,REASON_EFFECT)
	end
	Duel.BreakEffect()
end
