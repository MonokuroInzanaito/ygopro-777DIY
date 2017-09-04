--传说之弓兵 罗宾汉
function c99999954.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c99999954.xyzfilter),4,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99999954.secon)
	e1:SetTarget(c99999954.tg)
	e1:SetOperation(c99999954.op)
	c:RegisterEffect(e1)
	--announce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99991098,14))
	e2:SetHintTiming(0,TIMING_TOHAND)
	e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c99999954.cost)
	e2:SetTarget(c99999954.target)
	e2:SetOperation(c99999954.operation)
	c:RegisterEffect(e2)
    --actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c99999954.aclimit)
	e4:SetCondition(c99999954.actcon)
	c:RegisterEffect(e4)
	--[[negate attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetCost(c99999954.negcost)
	e5:SetOperation(c99999954.negop2)
	c:RegisterEffect(e5)--]]
end
function c99999954.xyzfilter(c)
	return  c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e7)
end
function c99999954.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99999954.filter(c)
	local code=c:GetCode()
	return (code==99999947)
end
function c99999954.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999954.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99999954.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c99999954.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
function c99999954.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99999954.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c99999954.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
		else
		Duel.ShuffleHand(1-tp)
	end
end
--[[function c99999954.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c99999954.tfilter(c)
     return c:IsFacedown() and  c:IsAbleToGrave()
end
function c99999954.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)  end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99999954.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return 
		Duel.IsExistingMatchingCard(c99999954.tfilter,tp,0,LOCATION_ONFIELD,1,nil) or
		Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) 
	end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c99999954.tfilter,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(999998,1) p=p+1 end
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) then t[p]=aux.Stringid(999998,0) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(999999,3))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(999998,1)
	local sg=nil
	e:SetLabel(opt)
end
function c99999954.operation(e,tp,eg,ep,ev,re,r,rp)
    local opt=e:GetLabel()
	local sg=nil
	if opt==0 then sg=Duel.SelectMatchingCard(tp,c99999954.tfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	else  sg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_HAND,1,1,nil) end
	local tc=sg:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local oc=Duel.SelectOption(tp,70,71,72)
	Duel.ConfirmCards(tp,sg)
	if opt~=0 then
	Duel.ShuffleHand(1-tp)
end
	if (oc==0 and tc:IsType(TYPE_MONSTER)) or (oc==1 and tc:IsType(TYPE_SPELL)) or (oc==2 and tc:IsType(TYPE_TRAP)) then
	  Duel.SendtoGrave(tc,nil,1,REASON_EFFECT)
end
end
function c99999954.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99999954.tpfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:IsAbleToHand()
end
function c99999954.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999954.tpfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99999954.tpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c99999954.tpfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c99999954.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(99999954)==0 end
	e:GetHandler():RegisterFlagEffect(99999954,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c99999954.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return Duel.IsChainDisablable(ev) and  tg and tg:IsContains(c) 
end
function c99999954.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99999954.negop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end
function c99999954.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 Duel.NegateAttack() 
end
--]]
function c99999954.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99999954.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() 
end