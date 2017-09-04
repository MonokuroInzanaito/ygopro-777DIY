--6th-死神执行人
function c66600607.initial_effect(c)
	 --handsp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600601,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c66600607.cost)
	e1:SetCondition(c66600607.con)
	e1:SetTarget(c66600607.tg)
	e1:SetOperation(c66600607.op)
	c:RegisterEffect(e1)
	--resp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151401,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c66600607.hsptg)
	e2:SetOperation(c66600607.hspop)
	c:RegisterEffect(e2)
	 --immue
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66600607,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetCondition(c66600607.imcon)
	e3:SetOperation(c66600607.imop)
	c:RegisterEffect(e3)
	 --
    local e5=Effect.CreateEffect(c)
	e5:SetRange(LOCATION_MZONE)
   e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e5:SetCode(EVENT_CHAINING)
   e5:SetCondition(c66600607.flcon)
	e5:SetOperation(c66600607.flop)
	c:RegisterEffect(e5)
end
function c66600607.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(66600607)==0 end
	c:RegisterFlagEffect(66600607,RESET_CHAIN,0,1)
end
function c66600607.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x66e) and c:GetLevel()==7
end
function c66600607.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g  then return false end
	return g:IsExists(c66600607.tgfilter,1,nil,tp)
end
function c66600607.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66600607.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c66600607.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e) and c:IsAbleToRemove()
end
function c66600607.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66600607.refilter(chkc) and chkc:IsControler(tp) end
	 if chk==0 then return Duel.IsExistingTarget(c66600607.refilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c66600607.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66600607.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(66600607,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c66600607.retcon)
		e1:SetOperation(c66600607.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
end
function c66600607.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(66600607)~=0
end
function c66600607.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c66600607.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600607)>0 
end
function c66600607.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(1)
		   e3:SetValue(c66600607.efilter)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			c:RegisterEffect(e3)
		end
end
function c66600607.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c66600607.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
   if not g  then return false end
  return g:IsContains(e:GetHandler())  
end
function c66600607.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600607,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end