--永夜的圣殿
function c18738107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18738107)
	e1:SetCost(c18738107.cost)
	e1:SetTarget(c18738107.target)
	e1:SetOperation(c18738107.operation)
	c:RegisterEffect(e1)
	--INDESTRUCTABLE
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	--e2:SetCountLimit(1)
	--e2:SetValue(c18738107.valcon)
	--c:RegisterEffect(e2)
	--IGNITION
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1876010,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c18738107.drcost)
	e3:SetTarget(c18738107.drtg)
	e3:SetOperation(c18738107.drop)
	c:RegisterEffect(e3)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(18738107)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e3)
end
function c18738107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738107.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738107.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function c18738107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c18738107.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c18738107.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xab0)
end
function c18738107.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c18738107.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(18738107,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c18738107.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c18738107.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c18738107.spfilter(c)
	return c:IsSetCard(0x3ab0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c18738107.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsReleasable() end
	if chk==0 then return Duel.IsExistingTarget(c18738107.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c18738107.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0  then
	Duel.Release(g,REASON_COST)
	end
end
function c18738107.thfilter(c)
	return c:IsAbleToHand() and c:IsFacedown()
end
function c18738107.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738107.thfilter,tp,LOCATION_REMOVED,0,1,nil) or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c18738107.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if chkc then return false end
	local b1=Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
	local b2=Duel.IsExistingTarget(c18738107.thfilter,tp,LOCATION_REMOVED,0,1,nil) 
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(18738107,2),aux.Stringid(18738107,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(18738107,2))
	else op=Duel.SelectOption(tp,aux.Stringid(18738107,3))+1 end
	e:SetLabel(op)
	if op==0 then
	local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	local tc=sg:GetFirst()
	if tc:IsFaceup() and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
	end
	else
	local g=Duel.GetMatchingGroup(c18738107.thfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end