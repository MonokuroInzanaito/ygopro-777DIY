--少女机关算尽
function c18706013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c18706013.target)
	e1:SetOperation(c18706013.activate)
	c:RegisterEffect(e1)
end
function c18706013.filter(c)
	return c:IsType(TYPE_TRAP)
end
function c18706013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c18706013.filter,tp,LOCATION_HAND,0,1,nil) end
end
function c18706013.activate(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local g=Duel.SelectMatchingCard(tp,c18706013.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			g:GetFirst():RegisterEffect(e1)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
end