--传说之魔术师 御神乐
function c99998946.initial_effect(c)
	--synchro
	 aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c99998946.synfilter),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER))
	c:EnableReviveLimit()
	--cannot be target
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c99998946.tgcon)
	e0:SetValue(aux.imval1)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c99998946.thcon)
	e2:SetTarget(c99998946.thtg)
	e2:SetOperation(c99998946.thop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99998946,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99998946)
	e3:SetCost(c99998946.cost)
	e3:SetCondition(c99998946.bcon)
	e3:SetTarget(c99998946.ltg)
	e3:SetOperation(c99998946.lop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(99998946,1))
	e4:SetTarget(c99998946.ftg)
	e4:SetOperation(c99998946.fop)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(99998946,2))
	e5:SetTarget(c99998946.wtg)
	e5:SetOperation(c99998946.wop)
	c:RegisterEffect(e5)
end
function c99998946.synfilter(c)
	return c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7) 
end
function c99998946.tgfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c99998946.tgcon(e)
	return Duel.IsExistingMatchingCard(c99998946.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c99998946.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99998946.thfilter(c,tp)
	return c:IsCode(99998945)  and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c99998946.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998946.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99998946.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99998946.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
   local tc=g:GetFirst() 
  if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(99998946,3))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function c99998946.bcon(e)
	return not Duel.IsExistingMatchingCard(c99998946.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c99998946.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99998946.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99998944,0,0x4011,3000,1900,12,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99998946.lop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99998944,0,0x4011,3000,1900,12,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,99998944)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	token:RegisterFlagEffect(99998946,RESET_EVENT+0x1fe0000,0,1)	
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(token)
		e1:SetCondition(c99998946.descon)
		e1:SetOperation(c99998946.desop)
		Duel.RegisterEffect(e1,tp)
end
function c99998946.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(99998946)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c99998946.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c99998946.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99998937,0,0x4011,2300,1000,12,RACE_THUNDER,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c99998946.fop(e,tp,eg,ep,ev,re,r,rp)
 if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end  
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99998937,0,0x4011,2300,1000,12,RACE_THUNDER,ATTRIBUTE_FIRE) then return end
	 for i=1,2 do 
   local token=Duel.CreateToken(tp,99998937)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	token:RegisterFlagEffect(99998946,RESET_EVENT+0x1fe0000,0,1)	  
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(token)
		e1:SetCondition(c99998946.descon)
		e1:SetOperation(c99998946.desop)
		Duel.RegisterEffect(e1,tp)
end
	 Duel.SpecialSummonComplete()
end
function c99998946.wtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99998936,0,0x4011,1700,2200,12,RACE_FAIRY,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99998946.wop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end 
   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99998936,0,0x4011,3000,1900,12,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	 for i=1,3 do
	local token=Duel.CreateToken(tp,99998936)
	 if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
	token:RegisterFlagEffect(99998946,RESET_EVENT+0x1fe0000,0,1)	  
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(token)
		e1:SetCondition(c99998946.descon)
		e1:SetOperation(c99998946.desop)
		Duel.RegisterEffect(e1,tp)
end
end
	 Duel.SpecialSummonComplete()
end