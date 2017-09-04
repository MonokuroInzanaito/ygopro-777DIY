--传说之骑士 兰斯洛特
function c99998981.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c99998981.synfilter),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--add code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(99999985)
	c:RegisterEffect(e1)
    --must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_EP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c99998981.becon)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c99998981.secon)
	e4:SetTarget(c99998981.tg)
	e4:SetOperation(c99998981.op)
	c:RegisterEffect(e4)
	--骑士不死于徒手
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99991095,5))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c99998981.discon)
	e5:SetTarget(c99998981.distg)
	e5:SetOperation(c99998981.disop)
	c:RegisterEffect(e5)
	--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetTarget(c99998981.desreptg)
	e6:SetOperation(c99998981.desrepop)
	e6:SetLabelObject(e6)
	c:RegisterEffect(e6)
	--only 1 can exists
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e7:SetCondition(c99998981.excon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e9)
end
function c99998981.synfilter(c)
	return  c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)
end
function c99998981.becon(e)
	local tc=e:GetHandler()
	return tc and tc:IsAttackable()
end
function c99998981.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99998981.filter(c)
	local code=c:GetCode()
	return (code==99999980)
end
function c99998981.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998981.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99998981.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c99998981.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
function c99998981.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and re:GetHandler():IsLocation(LOCATION_SZONE)
		and Duel.IsChainNegatable(ev) and re:GetHandler():GetSequence()<5
end
function c99998981.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99998981.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateRelatedChain(re:GetHandler(),RESET_TURN_SET)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	re:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	re:GetHandler():RegisterEffect(e2)
	if re:GetHandler():IsRelateToEffect(re) then
	re:GetHandler():CancelToGrave()
		 local e3=Effect.CreateEffect(e:GetHandler())
		    e3:SetCode(EFFECT_CHANGE_TYPE)
		    e3:SetType(EFFECT_TYPE_SINGLE)
		    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e3:SetReset(RESET_EVENT+0x1fc0000)
		    e3:SetValue(TYPE_SPELL+TYPE_EQUIP)
		    re:GetHandler():RegisterEffect(e3)
			local e4=Effect.CreateEffect(e:GetHandler())
		    e4:SetType(EFFECT_TYPE_SINGLE)
		    e4:SetCode(EFFECT_DISABLE)
		    e4:SetReset(RESET_EVENT+0x1fe0000)
		    re:GetHandler():RegisterEffect(e4)
		    local e5=Effect.CreateEffect(e:GetHandler())
		    e5:SetType(EFFECT_TYPE_SINGLE)
		    e5:SetCode(EFFECT_DISABLE_EFFECT)
		    e5:SetReset(RESET_EVENT+0x1fe0000)
		    re:GetHandler():RegisterEffect(e5)
			if not Duel.Equip(tp,re:GetHandler(),e:GetHandler(),false) then return end
			--Add Equip limit
			re:GetHandler():RegisterFlagEffect(99998981,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(re:GetHandler())
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e6:SetCode(EFFECT_EQUIP_LIMIT)
			e6:SetReset(RESET_EVENT+0x1fe0000)
			e6:SetValue(c99998981.eqlimit)
			re:GetHandler():RegisterEffect(e6)
			local e7=Effect.CreateEffect(e:GetHandler())
			e7:SetType(EFFECT_TYPE_EQUIP)
			e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
			e7:SetCode(EFFECT_UPDATE_ATTACK)
			e7:SetReset(RESET_EVENT+0x1fe0000)
			e7:SetValue(500)
			re:GetHandler():RegisterEffect(e7)
			local e8=e7:Clone()
			e8:SetCode(EFFECT_UPDATE_DEFENSE)
			re:GetHandler():RegisterEffect(e8)
            else Duel.SendtoGrave(re:GetHandler(),REASON_EFFECT) 
			end
end
function c99998981.eqlimit(e,c)
	return e:GetOwner()==c
end
function c99998981.repfilter(c)
	return  not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsType(TYPE_EQUIP)
end
function c99998981.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local eq=e:GetHandler():GetEquipGroup()
	local eq2=Duel.GetMatchingGroup(c99998981.repfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,nil) 
	if chk==0 then return eq2:GetCount()>0 or eq:GetCount()>0 end
	local sg
	if Duel.SelectYesNo(tp,aux.Stringid(99991097,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		if eq:GetCount()>0 and eq2:GetCount()>0 then
		eq:Merge(eq2)
		sg=Group.FilterSelect(eq,tp,c99998981.repfilter,1,1,nil)
		elseif  eq:GetCount()>0 and eq2:GetCount()==0 then
		sg=Group.FilterSelect(eq,tp,c99998981.repfilter,1,1,nil)
		elseif  eq2:GetCount()>0 and eq:GetCount()==0 then
	    sg=Group.FilterSelect(eq2,tp,c99998981.repfilter,1,1,nil)
		end	
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c99998981.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end
function c99998981.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x92e0) and c:IsType(TYPE_SYNCHRO)
end
function c99998981.excon(e)
	return Duel.IsExistingMatchingCard(c99998981.exfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end