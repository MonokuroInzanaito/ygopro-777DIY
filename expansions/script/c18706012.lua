--少女的先决
function c18706012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c18706012.cost)
	e1:SetOperation(c18706012.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c18706012.handcon)
	c:RegisterEffect(e2)
end
function c18706012.cffilter(c)
	return (c:IsSetCard(0xabb) or c:IsSetCard(0xab0)) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c18706012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706012.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c18706012.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c18706012.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetOperation(c18706012.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c18706012.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if  ep~=tp and rc:IsType(TYPE_SPELL+TYPE_TRAP) and (loc~=LOCATION_SZONE or rc:GetSequence()>=4) 
		then
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	    end
		--Duel.BreakEffect()
		--Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c18706012.handcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18706012.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c18706012.hdfilter(c)
	return c:IsFacedown() or not (c:IsSetCard(0xabb) or c:IsSetCard(0xab0))
end