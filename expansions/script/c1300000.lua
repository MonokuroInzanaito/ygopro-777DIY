--虚拟歌姬 洛天依
function c1300000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1300000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1300000)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1300000.spcon)
	e1:SetTarget(c1300000.sptg)
	e1:SetOperation(c1300000.spop)
	c:RegisterEffect(e1)
	--remove
	--[[local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2_1:SetCategory(CATEGORY_REMOVE)
	e2_1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2_1:SetCode(EVENT_SUMMON_SUCCESS)
	e2_1:SetTarget(c1300000.rtg)
	e2_1:SetOperation(c1300000.rop)
	c:RegisterEffect(e2_1)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2_2)
	local e2_3=e2_1:Clone()
	e2_3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_3)]]
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	--e3:SetCost(c1300000.eqcost)
	e3:SetTarget(c1300000.eqtg)
	e3:SetOperation(c1300000.eqop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(1300000,ACTIVITY_SPSUMMON,function(c) return c:IsSetCard(0x130) end)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0x14000)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,1300001)
	e4:SetCondition(c1300000.rtcon)
	e4:SetTarget(c1300000.rttg)
	e4:SetOperation(c1300000.rtop)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c1300000.rval)
	c:RegisterEffect(e5)
end
function c1300000.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x130)
end
function c1300000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1300000.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c1300000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMatchingGroupCount(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil)>0 and Duel.GetCustomActivityCount(1300000,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,Duel.GetMatchingGroupCount(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil),0,LOCATION_EXTRA)

end
function c1300000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetMatchingGroupCount(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil)<=0 then return end
--  if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,6,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
--  end
	Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c)
		return not c:IsSetCard(0x130)
	end)
	Duel.RegisterEffect(e2,tp)
end
function c1300000.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,Duel.GetMatchingGroupCount(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil),0,LOCATION_EXTRA)
end
function c1300000.rfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x130)
end
function c1300000.rop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil)<=0 then return end
--  if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c1300000.rfilter,tp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,6,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
--  end
end
--[[function c1300000.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end]]
function c1300000.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c1300000.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c1300000.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c1300000.eqfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c1300000.eqfilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c1300000.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown()
		or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetValue(RESET_TURN_SET)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e3)
	Duel.AdjustInstantly()
	Duel.Equip(tp,tc,c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c1300000.eqlimit)
	tc:RegisterEffect(e1,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetValue(1300400)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e4,true)
end
function c1300000.eqlimit(e,c)
	return e:GetOwner()==c
end

function c1300000.rtcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler()==e:GetHandler() then return false end
	return bit.band(r,REASON_EFFECT)==REASON_EFFECT and e:GetHandler():GetFlagEffect(1300000)==0
end
function c1300000.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c1300000.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if g and g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rtg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(rtg,nil,2,REASON_EFFECT) 
	end
end
function c1300000.rval(e,c)
	if c:IsReason(REASON_RETURN) then return 0 end
	c:RegisterFlagEffect(1300000,RESET_EVENT+0x1660000+RESET_PHASE+PHASE_END,0,1)
	return LOCATION_REMOVED
end
