--尸魂街
function c10107012.initial_effect(c)
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10107012,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c10107012.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10107012,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_DRAW_PHASE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,10107012)
	e3:SetCost(c10107012.cost)
	e3:SetOperation(c10107012.sumop)
	c:RegisterEffect(e3)
end
function c10107012.cost(e,tp,eg,ep,ev,re,r,rp,chk)\
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_HAND) and c:IsDiscardable()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()) end
	if c:IsLocation(LOCATION_HAND) then
	   Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
	   Duel.Remove(c,POS_FACEUP,REASON_COST)
	end
end
function c10107012.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_ZOMBIE)
	Duel.RegisterEffect(e1,tp)
end