--白井黑子
function c10910000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10910000.spcon)
	c:RegisterEffect(e1)	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10910000,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1)
	e4:SetCondition(c10910000.condition)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c10910000.attg)
	e4:SetOperation(c10910000.atop)
	c:RegisterEffect(e4)	
end
function c10910000.spfilter(c)
	return c:IsFaceup() and c:IsCode(5012602)
end
function c10910000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10910000.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10910000.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_END 
end
function c10910000.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c10910000.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10910000.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10910000.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10910000.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10910000.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local cp=tc:GetOwner()
	if tc:GetOriginalCode()~=10910000 and Duel.GetLocationCount(cp,LOCATION_MZONE)>0 then
	Duel.MoveToField(tc,cp,cp,LOCATION_MZONE,POS_FACEUP_ATTACK,true) 
	else if tc:GetOriginalCode()==10910000 then 
		tc:RegisterFlagEffect(10910000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c10910000.retcon)
		e1:SetOperation(c10910000.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
end
function c10910000.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(10910000)~=0
end
function c10910000.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
