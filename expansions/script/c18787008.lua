--魔王少女的召集令
function c18787008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18787008)
	e1:SetTarget(c18787008.target)
	e1:SetOperation(c18787008.activate)
	c:RegisterEffect(e1)
end
function c18787008.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb)
end
function c18787008.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xabb)
end
function c18787008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(c18787008.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(c18787008.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(18787008,0),aux.Stringid(18787008,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(18787008,0))
	else op=Duel.SelectOption(tp,aux.Stringid(18787008,1))+1 end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c18787008.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18787008.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	else
	Duel.DiscardHand(tp,c18787008.filter2,1,1,REASON_EFFECT+REASON_DISCARD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c18787008.indtg)
	e1:SetValue(c18787008.indval)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c18787008.indtg(e,c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x3abb)
end
function c18787008.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end