--死亡之翼 原初螺旋
function c60159024.initial_effect(c)
	c:SetUniqueOnField(1,0,60159024)
	c:SetCounterLimit(0x13,6)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60159024+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c60159024.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c60159024.acop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159024,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,60159024)
	e3:SetCost(c60159024.cost)
	e3:SetTarget(c60159024.destg)
	e3:SetOperation(c60159024.desop)
	c:RegisterEffect(e3)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60159024,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,6019024)
	e5:SetCost(c60159024.cost2)
	e5:SetTarget(c60159024.target2)
	e5:SetOperation(c60159024.activate2)
	c:RegisterEffect(e5)
end
function c60159024.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	if g:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159024,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg2)
		Duel.SendtoGrave(sg2,REASON_RULE)
	end
end
function c60159024.cfilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159024.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c60159024.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x13,ct)
	end
end
function c60159024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x13,3,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x13,3,REASON_COST)
end
function c60159024.filter(c)
	return c:IsAbleToRemove()
end
function c60159024.filter2(c)
	return c:IsAbleToGrave()
end
function c60159024.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159024.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c60159024.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c60159024.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60159024.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			local g2=Duel.GetMatchingGroup(c60159024.filter2,tp,0,LOCATION_REMOVED,nil)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159024,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159024,3))
				local sg=g2:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
			end
		end
	end
end
function c60159024.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x13,6,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x13,6,REASON_COST)
end
function c60159024.afilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and c:IsAbleToHand()
end
function c60159024.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159024.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60159024.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159024.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
