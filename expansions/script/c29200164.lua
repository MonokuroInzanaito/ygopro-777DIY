--凋叶棕-改-绝对的一方通行
function c29200164.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c29200164.mfilter,5,2,c29200164.ovfilter,aux.Stringid(29200164,0),2,c29200164.xyzop)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1)
	e1:SetCost(c29200164.tgcost)
	e1:SetTarget(c29200164.tgtg)
	e1:SetOperation(c29200164.tgop)
	c:RegisterEffect(e1)
	--discard deck & destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29200164)
	e2:SetCondition(c29200164.descon)
	e2:SetTarget(c29200164.distg)
	e2:SetOperation(c29200164.desop)
	c:RegisterEffect(e2)
	--to hand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(29200164,0))
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetCountLimit(1)
	e11:SetTarget(c29200164.thtg)
	e11:SetOperation(c29200164.thop)
	c:RegisterEffect(e11)
end
function c29200164.mfilter(c)
	return c:IsSetCard(0x53e0) 
end
function c29200164.ovfilter(c)
	return c:IsFaceup() and c:IsCode(29200023)
end
function c29200164.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29200164)==0 end
	Duel.RegisterFlagEffect(tp,29200164,RESET_PHASE+PHASE_END,0,1)
end
function c29200164.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29200164.tgfilter(c)
	return c:IsSetCard(0x53e0) and c:IsAbleToGrave()
end
function c29200164.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29200164.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c29200164.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29200164.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c29200164.cfilter(c)
	return c:IsSetCard(0x53e0) and c:IsLocation(LOCATION_GRAVE)
end
function c29200164.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function c29200164.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c29200164.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c29200164.cfilter,nil)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29200164,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sdg=dg:Select(tp,1,ct,nil)
		Duel.Destroy(sdg,REASON_EFFECT)
	end
end
function c29200164.filter(c)
	return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c29200164.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c29200164.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c29200164.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c29200164.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end