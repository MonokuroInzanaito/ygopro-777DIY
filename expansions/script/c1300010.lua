--虚拟歌姬 言和
function c1300010.initial_effect(c)
	--remove and special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,13000101)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1300010.sptg)
	e1:SetOperation(c1300010.spop)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0x14000)
	e4:SetCountLimit(1,1300010)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(c1300010.rtcon)
	e4:SetTarget(c1300010.rttg)
	e4:SetOperation(c1300010.rtop)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c1300010.rval)
	c:RegisterEffect(e5)
end
function c1300010.spfilter(c,ft)
	if ft<0 then return false end
	if ft==0 and not c:IsLocation(LOCATION_MZONE) then return false end
	return c:IsSetCard(0x130) and c:IsAbleToRemove()
end
function c1300010.spfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c1300010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(c1300010.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler(),ft) 
			and Duel.IsExistingTarget(c1300010.spfilter1,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c1300010.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler(),ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c1300010.spfilter1,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,1,e:GetHandler())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,tp,LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c1300010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if rg:GetCount()==2 and rg:FilterCount(function(c,tp) return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) end,nil,tp)>=(-ft) then
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local fid=c:GetFieldID()
			local og=Duel.GetOperatedGroup()
			local oc=og:GetFirst()
			while oc do
				oc:RegisterFlagEffect(1300010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
				oc=og:GetNext()
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(c1300010.retcon)
			e1:SetOperation(c1300010.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c1300010.retfilter(c,fid)
	return c:GetFlagEffectLabel(1300010)==fid
end
function c1300010.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c1300010.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1300010.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c1300010.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local rc=sg:GetFirst()
	while rc do
		if rc:IsPreviousLocation(LOCATION_GRAVE) then
			Duel.SendtoGrave(rc,REASON_EFFECT+REASON_RETURN)
		else
			Duel.ReturnToField(rc)
		end
		rc=sg:GetNext()
	end
end
function c1300010.rtcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler()==e:GetHandler() then return false end
	return bit.band(r,REASON_EFFECT)==REASON_EFFECT and e:GetHandler():GetFlagEffect(1300011)==0
end
function c1300010.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c1300010.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if g and g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48976825,0))
		local rtg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(rtg,REASON_EFFECT+REASON_RETURN) 
	end
end
function c1300010.rval(e,c)
	if c:IsReason(REASON_RETURN) then return 0 end
	c:RegisterFlagEffect(1300011,RESET_EVENT+0x1660000+RESET_PHASE+PHASE_END,0,1)
	return LOCATION_REMOVED
end