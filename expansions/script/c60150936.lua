--幻致的魅影
function c60150936.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetDescription(aux.Stringid(60150936,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,60150936)
	e5:SetCost(c60150936.cost3)
	e5:SetOperation(c60150936.op3)
	c:RegisterEffect(e5)
	--counter
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c60150936.ctcon)
	e6:SetOperation(c60150936.ctop)
	c:RegisterEffect(e6)
	--spsummon2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(58069384,2))
	e7:SetCategory(CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c60150936.spcon)
	e7:SetTarget(c60150936.sptg)
	e7:SetOperation(c60150936.spop)
	c:RegisterEffect(e7)
end
function c60150936.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c60150936.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60150936.cfilter,1,nil)
end
function c60150936.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1b,1)
end
function c60150936.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1b,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x1b,2,REASON_COST)
end
function c60150936.filter2(c)
	return c:IsSetCard(0x6b23) and c:IsAbleToHand()
end
function c60150936.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150936.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150936.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
end
function c60150936.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6b23) and c:IsFaceup()
end
function c60150936.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c60150936.spfilter,tp,0,LOCATION_DECK,1,nil) end
end
function c60150936.spop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150917,3))
	local g=Duel.SelectMatchingCard(tp,c60150936.spfilter,tp,0,LOCATION_DECK,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(1-tp,1)
	end
end