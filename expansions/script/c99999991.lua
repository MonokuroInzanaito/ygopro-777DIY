--传说之骑兵 美杜莎
function c99999991.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c99999991.spcon)
	e1:SetOperation(c99999991.spop)
	c:RegisterEffect(e1)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,99999991+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c99999991.tg)
	e2:SetOperation(c99999991.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99991099,9))
    e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c99999991.descost)
	e4:SetTarget(c99999991.destg)
	e4:SetOperation(c99999991.desop)
	c:RegisterEffect(e4)
end
function c99999991.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c99999991.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99999991.costfilter,tp,LOCATION_HAND,0,1,c)
end
function c99999991.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99999991.costfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c99999991.sfilter(c)
	local code=c:GetCode()
	return  code==99999968 and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99999991.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999991.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99999991.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99999991.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--[[function c99999991.ccfilter(c)
	return c:IsCode(99999938) and not c:IsDisabled()
end--]]
function c99999991.cfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_EQUIP)
end
function c99999991.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[if  Duel.IsExistingMatchingCard(c99999991.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,99999938)==0 then
    if chk==0 then return Duel.GetFlagEffect(tp,99999938)==0  end
	Duel.RegisterFlagEffect(tp,99999938,RESET_PHASE+PHASE_END,0,1)
	 else--]]
	if chk==0 then return Duel.IsExistingMatchingCard(c99999991.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99999991.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99999991.filter(c)
	return c:IsFaceup()
end
function c99999991.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999991.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c99999991.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99999991.filter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	local  tc=g:GetFirst() 
	while tc do 
	    local e1=Effect.CreateEffect(e:GetHandler())  
        e1:SetType(EFFECT_TYPE_SINGLE)  
        e1:SetCode(EFFECT_UPDATE_ATTACK)  
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
        e1:SetValue(g2*-300)  
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)  
	    tc:RegisterEffect(e2)
		local e3=e1:Clone()
        e3:SetValue(g2*300)  		
	    e:GetHandler():RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetValue(g2*300)  
        e4:SetCode(EFFECT_UPDATE_DEFENSE)  
	    e:GetHandler():RegisterEffect(e4)
	tc=g:GetNext()
	end
		Duel.Recover(tp,g2*300,REASON_EFFECT)

end
