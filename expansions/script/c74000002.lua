--剑与箭雨
function c74000002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c74000002.target)
	e1:SetOperation(c74000002.activate)
	c:RegisterEffect(e1)
end
function c74000002.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsAbleToRemove()
end
function c74000002.filter2(c)
	return not (c:IsFaceup() and c:IsDefensePos())
end
function c74000002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c74000002.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74000002.filter1,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c74000002.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c74000002.filter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(c74000002.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,g2:GetCount(),0,0)
end
function c74000002.filter(c)
	return c:IsFaceup() and c:IsDefenseBelow(1000) and c:IsDestructable()
end
function c74000002.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	local g=Duel.GetMatchingGroup(c74000002.filter2,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(c74000002.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
end
