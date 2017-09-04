--封印指定执行者 巴泽特
function c99998979.initial_effect(c)
	c:SetUniqueOnField(1,0,99998979)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c99998979.xyzfilter),7,2,c99998979.ovfilter,aux.Stringid(99991098,12),2,c99998979.xyzop)
	c:EnableReviveLimit()
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99998979.con)
	e1:SetTarget(c99998979.tg)
	e1:SetOperation(c99998979.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998979,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c99998979.cost)
	e2:SetTarget(c99998979.tg)
	e2:SetOperation(c99998979.op)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c99998979.ind)
	c:RegisterEffect(e3)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,99998979)
	e5:SetCondition(c99998979.negcon)
	e5:SetOperation(c99998979.negop)
	c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c99998979.xyzfilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_SPELLCASTER)
end
function c99998979.disfilter(c)
	return  c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsDiscardable()
end
function c99998979.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7))
	and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_SYNCHRO)
end
function c99998979.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998979.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99998979.disfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99998979.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99998979.filter(c)
	return  c:IsCode(99998978) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c99998979.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998979.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c99998979.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c99998979.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if (not tc:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(999999,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
function c99998979.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c99998979.ind(e,re,tp)
	return  re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and  e:GetHandlerPlayer()==1-tp
end
function c99998979.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev)
end
function c99998979.cfilter(c)
	return c:IsCode(99998978) and c:IsAbleToGrave()
end
function c99998979.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c99998979.cfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)  end
	local g=Duel.SelectMatchingCard(tp,c99998979.cfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99998979.negop(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.IsExistingMatchingCard(c99998979.cfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(99998979,0)) then
	local g=Duel.SelectMatchingCard(tp,c99998979.cfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.SelectOption(tp,aux.Stringid(99991095,7))
	Duel.SelectOption(1-tp,aux.Stringid(99991095,7))
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,REASON_EFFECT)
		end
end
end