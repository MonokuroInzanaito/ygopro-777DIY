--Days·黑化言叶
function c5200036.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x361),4,2,c5200036.ovfilter,aux.Stringid(5200036,0),2,c5200036.xyzop)
	c:EnableReviveLimit()
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c5200036.tgval)
	e2:SetCondition(c5200036.tgcon)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5200036,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c5200036.hdcon)
	e3:SetCost(c5200036.hdcost)
	e3:SetTarget(c5200036.hdtg)
	e3:SetOperation(c5200036.hdop)
	c:RegisterEffect(e3)
end
function c5200036.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c5200036.ovfilter(c)
	return c:IsFaceup() and c:IsCode(5200031) 
end
function c5200036.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200036.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c5200036.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c5200036.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c5200036.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c5200036.cfilter,1,nil,1-tp)
end
function c5200036.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c5200036.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c5200036.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c5200036.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c5200036.tgcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,5200031)
end