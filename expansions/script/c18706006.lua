--魔王少女
function c18706006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),4,4)
	c:EnableReviveLimit()
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69000994,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c18706006.condition)
	e2:SetCost(c18706006.cost)
	e2:SetTarget(c18706006.target)
	e2:SetOperation(c18706006.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35952884,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c18706006.discon)
	e3:SetCost(c18706006.cost)
	e3:SetTarget(c18706006.distg)
	e3:SetOperation(c18706006.disop)
	c:RegisterEffect(e3)
end
function c18706006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18706006.condition(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c18706006.cfilter,1,nil,1-tp)
end
function c18706006.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c18706006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function c18706006.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=tg:Select(p,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(1-tp)
		end
		Duel.ShuffleHand(1-p)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(54719828,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	if e:GetLabel()==0 then
	local tg1=Duel.GetFirstMatchingCard(c18706006.filter1,1-tp,LOCATION_DECK,0,nil)
	if tg1 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg1)
	end
	elseif e:GetLabel()==1 then
	local tg2=Duel.GetFirstMatchingCard(c18706006.filter2,1-tp,LOCATION_DECK,0,nil)
	if tg2 then
		Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg2)
	end
	else
	local tg3=Duel.GetFirstMatchingCard(c18706006.filter3,1-tp,LOCATION_DECK,0,nil)
	if tg3 then
		Duel.SendtoHand(tg3,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg3)
	end
	end 
end
function c18706006.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18706006.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c18706006.filter3(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c18706006.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c18706006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c18706006.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end