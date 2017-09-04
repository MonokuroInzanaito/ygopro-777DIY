--战场女武神 艾利西亚
function c11113018.initial_effect(c)
   --salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113018,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,11113018)
	e1:SetCondition(c11113018.condition)
	e1:SetTarget(c11113018.target)
	e1:SetOperation(c11113018.operation)
	c:RegisterEffect(e1)
	--send to hand & draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113018,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11113018)
	e2:SetTarget(c11113018.thtg)
	e2:SetOperation(c11113018.thop)
	c:RegisterEffect(e2)
end
function c11113018.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
	    and e:GetHandler():GetReasonCard():IsSetCard(0x15c)
end
function c11113018.filter(c)
	return c:IsSetCard(0x15c) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function c11113018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113018.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11113018.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11113018.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	    Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11113018.filter1(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_TUNER) and not c:IsType(TYPE_PENDULUM) and not c:IsCode(11113018) and c:IsAbleToHand()
end
function c11113018.filter2(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x15c) and c:IsType(TYPE_FUSION) and c:IsAbleToDeck()
end
function c11113018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11113018.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(c11113018.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(11113018,2),aux.Stringid(11113018,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(11113018,2))
	else op=Duel.SelectOption(tp,aux.Stringid(11113018,3))+1 end
	e:SetLabel(op)
	if op==0 then
	    e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	    e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c11113018.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c11113018.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    local g=Duel.SelectMatchingCard(tp,c11113018.filter1,tp,LOCATION_DECK,0,1,1,nil)
	    if g:GetCount()>0 then
		    Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
	    end
	else	
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
	        Duel.Draw(tp,1,REASON_EFFECT)
	    end
	end
end