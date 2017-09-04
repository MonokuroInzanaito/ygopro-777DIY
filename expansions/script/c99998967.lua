--投影魔术
function c99998967.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99998967+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99998967.cost)
	e1:SetTarget(c99998967.tg)
	e1:SetOperation(c99998967.op)
	c:RegisterEffect(e1)
end
function c99998967.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99998967.filter(c)
	return c:IsCode(99999987)  and c:IsFaceup() 
end
function c99998967.eqfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsFaceup() and not c:IsCode(99998966)
end
function c99998967.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  false end
	local g
	if  Duel.IsExistingMatchingCard(c99998967.filter,tp,LOCATION_ONFIELD,0,1,nil) then
	g=Duel.IsExistingTarget(c99998967.eqfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) 
	else
	g=Duel.IsExistingTarget(c99998967.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	and g and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local t1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local t2
	if  Duel.IsExistingMatchingCard(c99998967.filter,tp,LOCATION_MZONE,0,1,nil) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)   
   t2=Duel.SelectTarget(tp,c99998967.eqfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	t2=Duel.SelectTarget(tp,c99998967.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	end
	e:SetLabelObject(t2:GetFirst())  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c99998967.op(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc2~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsRelateToEffect(e) and tc2:IsFaceup() then
	local g=Group.FromCards(Duel.CreateToken(tp,99998966))
		local tg=g:GetFirst()
		Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		if Duel.Equip(tp,tg,tc1,true) then
		tg:CopyEffect(tc2:GetOriginalCode(),nil)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc2:GetOriginalCode())
		e1:SetReset(RESET_EVENT+0xfe0000)
		tg:RegisterEffect(e1)
end
end
end