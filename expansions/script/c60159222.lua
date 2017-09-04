--意料之外的背叛
function c60159222.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c60159222.condition)
	e1:SetTarget(c60159222.target)
	e1:SetOperation(c60159222.activate)
	c:RegisterEffect(e1)
end
function c60159222.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x5b25) then return false end
	return rp~=tp and Duel.IsChainNegatable(ev)
end
function c60159222.filter(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER)
end
function c60159222.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159222.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,eg,1,0,0)
	end
end
function c60159222.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60159222.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if re:GetHandler():IsRelateToEffect(re) and Duel.NegateActivation(ev) then
			Duel.Destroy(eg,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159204,1))
			local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g2:GetCount()>0 then
				Duel.HintSelection(g2)
				local tc=g2:GetFirst()
				tc:AddCounter(0x1137+COUNTER_NEED_ENABLE,1)
			end
		end
	end
end
