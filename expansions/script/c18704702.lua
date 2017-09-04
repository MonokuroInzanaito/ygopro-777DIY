--要塞少女 拘束舰
function c18704702.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),aux.NonTuner(Card.IsSetCard,0xabb),1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(51316684,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c18704702.target)
	e4:SetOperation(c18704702.operation)
	c:RegisterEffect(e4)
end
function c18704702.filter(c)
	return c:IsFaceup()
end
function c18704702.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c18704702.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18704702.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18704702.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c18704702.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e2)
		--local e3=Effect.CreateEffect(e:GetHandler())
		--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--e3:SetCode(EVENT_PHASE+PHASE_END)
		--e3:SetRange(LOCATION_MZONE)
		--e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		--e3:SetCountLimit(1)
		--e3:SetOperation(c18704702.retop)
		--e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		--tc:RegisterEffect(e3)
	end
end
function c18704702.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.GetControl(c,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		if not c:IsImmuneToEffect(e) and c:IsAbleToChangeControler() then
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end