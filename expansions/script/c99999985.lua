--传说之狂战士 兰斯洛特
function c99999985.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)	
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c99999985.tg)
	e1:SetOperation(c99999985.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--level attribute race change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99991099,10))
    e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c99999985.lvcost)
	e3:SetTarget(c99999985.lvtar)
	e3:SetOperation(c99999985.lvop)
	c:RegisterEffect(e3)
	 --must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_EP)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c99999985.becon)
	c:RegisterEffect(e5)
end
function c99999985.filter(c)
	local code=c:GetCode()
	return (code==99999980) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99999985.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999985.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99999985.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c99999985.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
--[[function c99999985.ccfilter(c)
	return c:IsCode(99999938) and not c:IsDisabled()
end--]]
function c99999985.cfilter(c)
	return c:IsDiscardable() 
end
function c99999985.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[if  Duel.IsExistingMatchingCard(c99999985.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,99999938)==0 then
    if chk==0 then return Duel.GetFlagEffect(tp,99999938)==0  end
	Duel.RegisterFlagEffect(tp,99999938,RESET_PHASE+PHASE_END,0,1)
	 else--]]
	if chk==0 then return Duel.IsExistingMatchingCard(c99999985.cfilter,tp,LOCATION_HAND,0,1,nil)   end
	Duel.DiscardHand(tp,c99999985.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99999985.lvfilter(c)
	return c:GetLevel()>0
end
function c99999985.lvtar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c99999985.lvfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99999985.lvfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_REMOVED,1,1,e:GetHandler(),e,tp)
end
function c99999985.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(tc:GetRace())
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(tc:GetAttribute())
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(tc:GetCode())
		c:RegisterEffect(e4)
	end
end
function c99999985.becon(e)
	local tc=e:GetHandler()
	return tc and tc:IsAttackable()
end