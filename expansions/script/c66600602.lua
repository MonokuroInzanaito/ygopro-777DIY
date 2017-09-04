--6th-饵食
function c66600602.initial_effect(c)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600602,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c66600602.tg)
	e1:SetOperation(c66600602.op)
	c:RegisterEffect(e1)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66600602,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
   e2:SetType(EFFECT_TYPE_QUICK_O)
   e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c66600602.spcon)
	e2:SetTarget(c66600602.sptg)
	e2:SetOperation(c66600602.spop)
	c:RegisterEffect(e2)
  --
	 local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetCondition(c66600602.flcon)
	e3:SetOperation(c66600602.flop)
	c:RegisterEffect(e3)
end
function c66600602.tfilter(c)
	return  c:IsSetCard(0x66e) and not c:IsType(TYPE_TUNER)
end
function c66600602.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c66600602.tfilter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c66600602.tfilter,tp,LOCATION_MZONE,0,1,nil)  end
	local g=Duel.SelectTarget(tp,c66600602.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66600602.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c66600602.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600602)>0 
end
function c66600602.filter(c,e,tp)
	return  c:IsSetCard(0x66e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66600602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66600602.filter,tp,LOCATION_HAND,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66600602.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66600602.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66600602.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600602.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600602,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end