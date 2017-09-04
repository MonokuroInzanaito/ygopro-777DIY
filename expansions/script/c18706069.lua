--魔女梅林
function c18706069.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18706069.spcon)
	e1:SetCost(c18706069.cost)
	e1:SetOperation(c18706069.spop)
	c:RegisterEffect(e1)
end
function c18706069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  end

end
function c18706069.filter(c,e,tp)
	return c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)
end
function c18706069.filter2(c,e,tp)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c18706069.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18706069.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c18706069.filter2,tp,0,LOCATION_ONFIELD,2,nil) and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function c18706069.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c18706069.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	local ae=tc:GetActivateEffect()
	local e1=Effect.CreateEffect(tc)
	e1:SetDescription(ae:GetDescription())
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	e1:SetCost(c18706069.spellcost)
	e1:SetTarget(c18706069.spelltg)
	e1:SetOperation(c18706069.spellop)
	tc:RegisterEffect(e1)
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c18706069.spellcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c18706069.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c18706069.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end