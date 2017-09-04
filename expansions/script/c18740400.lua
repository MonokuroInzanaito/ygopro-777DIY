--狂猎 奧丁
function c18740400.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab5),7,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1870000,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,18740400)
	e1:SetCost(c18740400.cost)
	e1:SetTarget(c18740400.target)
	e1:SetOperation(c18740400.operation)
	c:RegisterEffect(e1)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18740400,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c18740400.spcon)
	e4:SetOperation(c18740400.spop)
	c:RegisterEffect(e4)
end
function c18740400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	local g1=g:GetCount()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsPlayerCanDiscardDeck(1-tp,g1) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	e:SetLabel(ct)
end
function c18740400.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,ct) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c18740400.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
end
function c18740400.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp
end
function c18740400.spcon(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
	return eg:IsExists(c18740400.spfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and not re:GetHandler():IsCode(18740400)
	else
	return eg:IsExists(c18740400.spfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
	end
end
function c18740400.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_XYZ) then return end
	local ct1=eg:FilterCount(c18740400.spfilter,nil,tp)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct1>ct2 then ct1=ct2 end
	local g=Duel.GetDecktopGroup(1-tp,ct1)
	Duel.DisableShuffleCheck()
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
end