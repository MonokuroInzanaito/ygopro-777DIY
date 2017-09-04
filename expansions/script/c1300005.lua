--虚拟歌姬 东方栀子
function c1300005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1300005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1300005)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1300005.spcon)
	e1:SetTarget(c1300005.sptg)
	e1:SetOperation(c1300005.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c,tp,sumtp,sumpos)
		return not c:IsSetCard(0x130)
	end)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(0x14000)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,1300006)
	e4:SetCondition(c1300005.rtcon)
	e4:SetTarget(c1300005.rttg)
	e4:SetOperation(c1300005.rtop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c1300005.rval)
	c:RegisterEffect(e5)
end
function c1300005.rtcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler()==e:GetHandler() then return false end
	return bit.band(r,REASON_EFFECT)==REASON_EFFECT and e:GetHandler():GetFlagEffect(1300005)==0
end
function c1300005.rtfilter(c,e,tp)
	if not c:IsSetCard(0x130) or c:IsFacedown() then return false end
	if c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then return true end
	if (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable() then return true end
	return false
end
function c1300005.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1300005.rtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1300005.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1300005.rtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler(),e,tp)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local rtg=g:Select(tp,1,1,nil)
		local rc=rtg:GetFirst()
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
			Duel.ConfirmCards(1-tp,rc)
		end
	end
end
function c1300005.cfilter2(c)
	return c:IsFacedown() or not c:IsSetCard(0x130)
end
function c1300005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1300005.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c1300005.rfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x130)
end
function c1300005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMatchingGroupCount(c1300005.rfilter,tp,LOCATION_EXTRA,0,nil)>0 end
	local g=Duel.GetMatchingGroup(c1300005.rfilter,tp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,63,nil)
	e:SetLabel(rg:GetCount())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,Duel.GetMatchingGroupCount(c1300005.rfilter,tp,LOCATION_EXTRA,0,nil),0,LOCATION_EXTRA)
end
function c1300005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Damage(tp,e:GetLabel()*900,REASON_EFFECT)
end
function c1300005.rval(e,c)
	if c:IsReason(REASON_RETURN) then return 0 end
	c:RegisterFlagEffect(1300005,RESET_EVENT+0x1660000+RESET_PHASE+PHASE_END,0,1)
	return LOCATION_REMOVED
end