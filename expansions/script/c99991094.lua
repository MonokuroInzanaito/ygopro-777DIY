--背叛之魔女 美狄亚
function c99991094.initial_effect(c)
	c:SetUniqueOnField(1,0,99991094)
	--synchro
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c99991094.synfilter),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local g=Group.CreateGroup()
	g:KeepAlive()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(c99991094.eqcheck)
	c:RegisterEffect(e1)
	e1:SetLabelObject(g)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
   e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c99991094.thcon)
	e3:SetTarget(c99991094.thtg)
	e3:SetOperation(c99991094.thop)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99991094,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c99991094.spcon)
	e4:SetTarget(c99991094.sptg)
	e4:SetOperation(c99991094.spop)
	c:RegisterEffect(e4)
	--Remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99991094,4))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c99991094.rmcon)
	e5:SetTarget(c99991094.rmtg)
	e5:SetOperation(c99991094.rmop)
	c:RegisterEffect(e5)
	e5:SetLabelObject(g)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99991094,5))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c99991094.descon)
	e6:SetCost(c99991094.descost)
	e6:SetTarget(c99991094.destg)
	e6:SetOperation(c99991094.desop)
	c:RegisterEffect(e6)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetCondition(c99991094.incon)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetValue(c99991094.effval)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e8)
end
function c99991094.synfilter(c)
	return c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7) 
end
function c99991094.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:GetLabelObject():Merge(g)
end
function c99991094.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99991094.thfilter(c)
	return c:IsCode(99999976) 
end
function c99991094.sfilter(c)
	return c:IsType(TYPE_FIELD) and (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e5)) and c:IsAbleToHand()
end
function c99991094.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991094.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99991094.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local  g=Duel.SelectMatchingCard(tp,c99991094.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   Duel.SendtoHand(tc,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,tc)
		end
	end 
	local cg=Duel.GetMatchingGroup(c99991094.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99991094,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end 
end
function c99991094.dfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c99991094.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99991094.dfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c99991094.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99991096,0,0x4011,2000,2000,4,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c99991094.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99991096,0,0x4011,2000,2000,4,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,99991096)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1,true)
		end
	Duel.SpecialSummonComplete()
end
function c99991094.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE and ph<=PHASE_DAMAGE_CAL )
end
function c99991094.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	local g=c:GetEquipGroup()
	local sg=Group.CreateGroup()
	sg:Merge(g)
	sg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function c99991094.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	local sg=Group.CreateGroup()
	sg:Merge(g)
	sg:AddCard(c)
	if c:IsRelateToEffect(e) and Duel.Remove(sg,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(e)
		e1:SetCountLimit(1)
		e1:SetOperation(c99991094.retop)
		Duel.RegisterEffect(e1,tp)
	end 
end
function c99991094.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.ReturnToField(e:GetHandler()) then
	local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)  
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local g=e:GetLabelObject():GetLabelObject()
	local tc=g:GetFirst()
	while tc do
	if tc:GetControler()==tp and ft1>0 then
	Duel.Equip(tp,tc,e:GetHandler(),true,true)
	else if tc:GetControler()==1-tp and ft2>0 then
	Duel.Equip(1-tp,tc,e:GetHandler(),true,true)
	end
	end
	tc=g:GetNext()  
	end
	Duel.EquipComplete()
	e:GetLabelObject():GetLabelObject():Clear()
	end
end
function c99991094.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c99991094.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local ct=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,ct,nil)
	e:SetLabel(g:GetCount())
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99991094.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,e:GetLabel(),e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99991094.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c99991094.incon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,99991096)
end
function c99991094.effval(e,te,tp)
	return tp~=e:GetHandlerPlayer()
end