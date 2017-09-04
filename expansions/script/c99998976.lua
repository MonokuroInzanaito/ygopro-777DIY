--不屈的意志
function c99998976.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99998976.con)
	e1:SetOperation(c99998976.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92826944,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_SPSUMMON)
	e2:SetCondition(c99998976.con2)
	e2:SetCost(c99998976.cost)
	e2:SetTarget(c99998976.target)
	e2:SetOperation(c99998976.operation)
	c:RegisterEffect(e2)
end
function c99998976.filter(c)
	return c:IsSetCard(0x92e0) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c99998976.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998976.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c99998976.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c99998976.imtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c99998976.efilter)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c99998976.imtg2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(c99998976.efilter)
	Duel.RegisterEffect(e3,tp)
end
function c99998976.imtg(e,c)
	return c:IsSetCard(0x92e0) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c99998976.imtg2(e,c)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c99998976.efilter(e,te)
	return  te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99998976.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ((ph>=PHASE_BATTLE and ph<=PHASE_DAMAGE_CAL) or 
	ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
	and e:GetHandler():GetTurnID()~=Duel.GetTurnCount() and
	(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c99998976.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99998976.spfilter(c,e,tp)
	return  c:IsSetCard(0x92e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99998976.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99998976.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c99998976.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99998976.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99998976.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
