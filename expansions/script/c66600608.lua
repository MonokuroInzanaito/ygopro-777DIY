--6th-魅影看护妇
function c66600608.initial_effect(c)
	 --remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600608,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c66600608.rmcon)
	e1:SetTarget(c66600608.rmtg)
	e1:SetOperation(c66600608.rmop)
	c:RegisterEffect(e1)
	--hsp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151401,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c66600608.hsptg)
	e2:SetOperation(c66600608.hspop)
	c:RegisterEffect(e2)
	--immue
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27978707,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c66600608.con)
	e3:SetCost(c66600608.cost)
	e3:SetOperation(c66600608.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCost(c66600608.cost2)
	e4:SetRange(LOCATION_HAND)
	c:RegisterEffect(e4)
 --
	 local e5=Effect.CreateEffect(c)
	e5:SetRange(LOCATION_MZONE)
   e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e5:SetCode(EVENT_CHAINING)
   e5:SetCondition(c66600608.flcon)
	e5:SetOperation(c66600608.flop)
	c:RegisterEffect(e5)
end
function c66600608.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600608)>0 
end
function c66600608.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c66600608.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600608.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c66600608.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66600608.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		g:GetFirst():RegisterFlagEffect(66600608,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(g:GetFirst())
		e1:SetCountLimit(1)
		e1:SetCondition(c66600608.retcon)
		e1:SetOperation(c66600608.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c66600608.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(66600608)~=0
end
function c66600608.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c66600608.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e) and c:IsAbleToHand() and not c:IsCode(66600608)
end
function c66600608.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66600608.refilter(chkc) and chkc:IsControler(tp) end
	 if chk==0 then return Duel.IsExistingTarget(c66600608.refilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c66600608.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66600608.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c66600608.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
   local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	 return g and tc:IsFaceup() and  tc:IsSetCard(0x66e) and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end
function c66600608.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66600608.op(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:GetFirst():IsFaceup()  then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(1)
			 e3:SetValue(c66600608.efilter)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			g:GetFirst():RegisterEffect(e3)
end
end
function c66600608.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c66600608.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c66600608.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600608.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600608,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end