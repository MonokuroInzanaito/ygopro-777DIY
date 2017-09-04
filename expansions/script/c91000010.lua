--天印-紫微
function c91000010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c91000010.efilter)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91000010,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xe10)
	end)
	e2:SetCost(c91000010.secost)
	e2:SetTarget(c91000010.setg)
	e2:SetOperation(c91000010.seop)
	c:RegisterEffect(e2)
end
function c91000010.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c91000010.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c91000010.cfilter(c)
	return c:GetLevel()==2 and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c91000010.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000010.cfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c91000010.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91000010,1))
	local g=Duel.SelectMatchingCard(tp,c91000010.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToHand()
	local b2=tc:IsAbleToGrave()
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(91000010,2),aux.Stringid(91000010,3))
	elseif b1 then op=0 else op=1 end
	if op==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	elseif op==1 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
