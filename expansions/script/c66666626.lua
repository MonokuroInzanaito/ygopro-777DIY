--サイバー・リペア・プラント
function c66666626.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c66666626.target)
	e1:SetOperation(c66666626.activate)
	c:RegisterEffect(e1)
end
function c66666626.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x661) and c:IsAbleToDeck()
end
function c66666626.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x664)
end
function c66666626.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x661)
end
function c66666626.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c66666626.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666626.filter1,tp,LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c66666626.filter1,tp,LOCATION_REMOVED,0,5,5,nil)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c66666626.filter2,tp,LOCATION_DECK,0,2,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(c66666626.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(66666626,0),aux.Stringid(66666626,1))
		end
	elseif b1 then
		op=0
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
		e:SetProperty(0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		e:SetProperty(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c66666626.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		local op=e:GetLabel()
		if op~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c66666626.filter2,tp,LOCATION_DECK,0,2,2,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		else
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end

