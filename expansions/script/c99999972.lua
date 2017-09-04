--狂化召唤术
function c99999972.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991095,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99999972+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99999972.cost)
	e1:SetTarget(c99999972.target)
	e1:SetOperation(c99999972.operation)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)	
	e2:SetDescription(aux.Stringid(99991095,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabel(0)
	e2:SetCountLimit(1,99999972+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c99999972.cost2)
	e2:SetTarget(c99999972.target2)
	e2:SetOperation(c99999972.activate)
	c:RegisterEffect(e2)
end
function c99999972.filter(c)
     return c:IsDiscardable() and c:IsType(TYPE_EQUIP)
end
function c99999972.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999972.filter,tp,LOCATION_HAND,0,1,nil) and Duel.CheckLPCost(tp,1000) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,c99999972.filter,1,1,REASON_COST+REASON_DISCARD)
    Duel.PayLPCost(tp,1000)
end
function c99999972.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and  (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7))
end
function c99999972.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99999972.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c99999972.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99999972.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if  tc then
		if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(800)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		if not tc:IsSetCard(0x92e0) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4,true)
	    local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_MUST_ATTACK)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
	    e6:SetType(EFFECT_TYPE_FIELD)
	    e6:SetCode(EFFECT_CANNOT_EP)
	    e6:SetRange(LOCATION_MZONE)
	    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e6:SetTargetRange(1,0)
	    e6:SetCondition(c99999972.becon)
		tc:RegisterEffect(e6,true)
		end
		Duel.SpecialSummonComplete()
		local e7=Effect.CreateEffect(c)
	    e7:SetType(EFFECT_TYPE_FIELD)
    	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e7:SetTargetRange(1,0)
	    e7:SetTarget(c99999972.splimit)
	    e7:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e7,tp)
	end
end
end
function c99999972.becon(e)
	local tc=e:GetHandler()
	return tc and tc:IsAttackable()
end
function c99999972.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7)) 
end
function c99999972.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end	
end
function c99999972.tgfilter(c,e,tp)
	local att,lv
	if c:IsType(TYPE_XYZ) then
	lv=c:GetOriginalRank()
	else
	lv=c:GetOriginalLevel()
	end
	local att=c:GetOriginalAttribute()
	return  c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99999972.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv,att)
end
function c99999972.spfilter2(c,e,tp,lv,att)
	return c:GetLevel()==lv and c:GetAttribute()==att 
	and (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99999972.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c99999972.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.CheckLPCost(tp,1000) end
		e:SetLabel(0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99999972.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_COST)
    Duel.PayLPCost(tp,1000)
	Duel.SetTargetCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
end
function c99999972.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tg=Duel.GetFirstTarget()
	if not tg:IsRelateToEffect(e) then return end
	local att,lv
	if tg:IsType(TYPE_XYZ) then
	lv=tg:GetOriginalRank()
	else
	lv=tg:GetOriginalLevel()
	end
	local att=tg:GetOriginalAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99999972.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv,att)
	local tc=g:GetFirst()
	if  tc then
		if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
        if not tc:IsSetCard(0x92e0) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_MUST_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
	    e4:SetType(EFFECT_TYPE_FIELD)
	    e4:SetCode(EFFECT_CANNOT_EP)
	    e4:SetRange(LOCATION_MZONE)
	    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e4:SetTargetRange(1,0)
	    e4:SetCondition(c99999972.becon)
		tc:RegisterEffect(e4,true)
		end
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetOperation(c99999972.desop)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetCountLimit(1)
		tc:RegisterEffect(e5,true)
		Duel.SpecialSummonComplete()
		local e6=Effect.CreateEffect(c)
	    e6:SetType(EFFECT_TYPE_FIELD)
    	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e6:SetTargetRange(1,0)
	    e6:SetTarget(c99999972.splimit)
	    e6:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e6,tp)
end
end
end
function c99999972.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end