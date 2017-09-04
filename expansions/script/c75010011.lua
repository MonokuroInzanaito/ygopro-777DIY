--战术人形制造
function c75010011.initial_effect(c)
	aux.AddRitualProcEqual2(c,c75010011.ritual_filter)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75010011,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c75010011.cost)
	e1:SetTarget(c75010011.tg)
	e1:SetOperation(c75010011.op)
	c:RegisterEffect(e1)
end
function c75010011.ritual_filter(c)
	return c:IsSetCard(0x520) and bit.band(c:GetType(),0x81)==0x81
end
function c75010011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75010011.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75010011.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c75010011.tdfilter(c)
	return c:IsSetCard(0x520) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToDeckAsCost()
end
function c75010011.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75010011.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end