--山铜锁链
function c11113091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11113091+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11113091.cost)
	e1:SetTarget(c11113091.target)
	e1:SetOperation(c11113091.activate)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c11113091.efcon)
	e2:SetOperation(c11113091.efop)
	c:RegisterEffect(e2)
end
function c11113091.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) 
	    and Duel.IsExistingMatchingCard(c11113091.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c11113091.spfilter(c,e,tp,lv)
    return c:IsCode(11113091)
        and Duel.IsPlayerCanSpecialSummonMonster(tp,11113091,0,0x21,lv,0,0,RACE_MACHINE,ATTRIBUTE_EARTH)
end		
function c11113091.dfilter(c)
	return c:IsFaceup() and c:IsCode(11113091)
end
function c11113091.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(11113091,2))
	Duel.SelectOption(1-tp,aux.Stringid(11113091,2))
end
function c11113091.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11113091.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11113091.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
		and not Duel.IsExistingMatchingCard(c11113091.dfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c11113091.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c11113091.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,11113091,0,0x21,lv,0,0,RACE_MACHINE,ATTRIBUTE_EARTH) then
	    local g=Duel.GetMatchingGroup(c11113091.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,lv)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		sg:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(sg,0,tp,tp,true,false,POS_FACEUP)
		sg:AddMonsterAttributeComplete()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		sg:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		sg:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		sg:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		sg:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetCountLimit(1)
		e5:SetOperation(c11113091.thop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		sg:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(lv)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		sg:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
	end
end
function c11113091.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c11113091.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c11113091.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(11113091,1))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c11113091.ctcon)
	e1:SetCost(c11113091.ctcost)
	e1:SetTarget(c11113091.cttg)
	e1:SetOperation(c11113091.ctop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11113091,0))
end
function c11113091.cfilter(c,tp)
	return c:GetPreviousCodeOnField()==11113091 and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousControler()==tp
		and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousSequence()<5
end
function c11113091.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11113091.cfilter,1,nil,tp)
end
function c11113091.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11113091.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c11113091.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.GetControl(c,1-tp)
end