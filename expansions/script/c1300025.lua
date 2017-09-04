--虚拟歌姬 夏语遥
function c1300025.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1300025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,1300025)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c1300025.sptg)
	e1:SetOperation(c1300025.spop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0x14000)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,1300006)
	e4:SetCondition(c1300025.rtcon)
	e4:SetTarget(c1300025.rttg)
	e4:SetOperation(c1300025.rtop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c1300025.rval)
	c:RegisterEffect(e5)
end
function c1300025.rfilter(c,ft)
	if ft==0 and not c:IsLocation(LOCATION_MZONE) then return false end
	return c:IsAbleToRemoveAsCost()
end
function c1300025.rfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x130)
end
function c1300025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMatchingGroupCount(c1300025.rfilter1,tp,LOCATION_EXTRA,0,nil)>0 and Duel.GetMatchingGroupCount(c1300025.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),ft)>0 end
	local g=Duel.GetMatchingGroup(c1300025.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler(),ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,1,nil)
	local g2=Duel.GetMatchingGroup(c1300025.rfilter1,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg2=g2:Select(tp,1,1,nil)
	rg:Merge(rg2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
end
function c1300025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_INACTIVATE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetValue(c1300025.effectfilter)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_DISEFFECT)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e5:SetValue(c1300025.effectfilter)
		Duel.RegisterEffect(e5,tp)
	end
end
function c1300025.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsSetCard(0x130)
end
function c1300025.rtcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler()==e:GetHandler() then return false end
	return bit.band(r,REASON_EFFECT)==REASON_EFFECT and e:GetHandler():GetFlagEffect(1300025)==0
end
function c1300025.rtfilter(c,e,tp)
	if not c:IsSetCard(0x130) or c:IsFacedown() then return false end
	return c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1300025.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1300025.rtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1300025.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1300025.rtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler(),e,tp)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rtg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(rtg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1300025.rval(e,c)
	if c:IsReason(REASON_RETURN) then return 0 end
	c:RegisterFlagEffect(1300025,RESET_EVENT+0x1660000+RESET_PHASE+PHASE_END,0,1)
	return LOCATION_REMOVED
end