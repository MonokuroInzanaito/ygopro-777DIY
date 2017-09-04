--无垢识 空之境界
function c18706067.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97997309,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1,18706067)
	e3:SetCondition(c18706067.condition)
	e3:SetTarget(c18706067.target3)
	e3:SetOperation(c18706067.activate3)
	c:RegisterEffect(e3)
end
function c18706067.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb) and (c:IsLevelAbove(8) or c:IsRankAbove(8))
end
function c18706067.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c18706067.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18706067.filter3(c)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function c18706067.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706067.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c18706067.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c18706067.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18706067.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if not tc:IsDisabled() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and 1000>=Duel.GetLP(1-tp) then
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
	end
end
