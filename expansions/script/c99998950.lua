--传说之剑士 诺因·勒弗
function c99998950.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c99998950.synfilter),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9999109,7))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99998950.con)
	e1:SetTarget(c99998950.setg)
	e1:SetOperation(c99998950.seop)
	c:RegisterEffect(e1)
	--魔王制造
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998950,0))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c99998950.cost)
	e2:SetTarget(c99998950.atg)
	e2:SetOperation(c99998950.aop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(99998950,1))
	e3:SetTarget(c99998950.rtg)
	e3:SetOperation(c99998950.rop)
	c:RegisterEffect(e3)
    --immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c99998950.efilter)
	c:RegisterEffect(e4)   
   --disable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c99998950.disop)
    c:RegisterEffect(e5)
end
function c99998950.synfilter(c)
	return  c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7)
end
function c99998950.con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99998950.filter(c)
	local code=c:GetCode()
	return (code==99998949) 
end
function c99998950.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998950.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    and Duel.IsPlayerCanDraw(tp,1)	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99998950.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99998950.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Equip(tp,tc,c)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
function c99998950.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99998950.afilter(c)
	return c:IsFaceup() and c:GetAttribute()~=ATTRIBUTE_DARK
end
function c99998950.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c99998950.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c99998950.aop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99998950.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
	if tc:IsFaceup()  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	tc=g:GetNext()
	end
end
function c99998950.rfilter(c)
	return c:IsFaceup() and c:GetRace()~=RACE_FIEND
end
function c99998950.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c99998950.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c99998950.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99998950.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
	if tc:IsFaceup()  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_FIEND)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	tc=g:GetNext()
	end
end
function c99998950.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and  te:GetHandler():IsRace(RACE_FIEND+RACE_ZOMBIE) and te:GetHandler()~=e:GetHandler()
end
function c99998950.disop(e,tp,eg,ep,ev,re,r,rp)
    if not re:GetHandler():IsType(TYPE_SPELL) or rp==tp then return end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsContains(e:GetHandler()) then 
        Duel.NegateEffect(ev)
        if re:GetHandler():IsRelateToEffect(re) then
            Duel.Destroy(re:GetHandler(),REASON_EFFECT)
        end
    end
end