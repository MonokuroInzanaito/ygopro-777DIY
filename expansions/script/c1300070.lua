--虚拟歌姬 益和团
function c1300070.initial_effect(c)
	c:SetSPSummonOnce(1300070)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
--  e1:SetDescription(aux.Stringid(1300070,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c1300070.spcon)
	e1:SetTarget(c1300070.sptg)
	e1:SetOperation(c1300070.spop)
	c:RegisterEffect(e1)
	--activate limit 2
	--[[local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_CHAINING)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetOperation(c1300070.aclimit1)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_2:SetCode(EVENT_CHAIN_NEGATED)
	e2_2:SetRange(LOCATION_MZONE)
	e2_2:SetOperation(c1300070.aclimit2)
	e2_2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2_2)]]
	local e2_3=Effect.CreateEffect(c)
	e2_3:SetType(EFFECT_TYPE_FIELD)
	e2_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_3:SetTargetRange(0,1)
	e2_3:SetRange(LOCATION_MZONE)
	e2_3:SetCondition(c1300070.econ)
	e2_3:SetValue(c1300070.elimit)
	c:RegisterEffect(e2_3)
end
function c1300070.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function c1300070.spfilter(c,player)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()==1300010 and c:GetPreviousControler()==player
end
function c1300070.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1300070.spfilter,1,nil,tp)
end
function c1300070.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsFaceup() 
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c1300070.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if g:GetCount()>0 then
			local tg=g:RandomSelect(tp,1)
			if tg:GetFirst():IsAbleToRemove() then
				Duel.BreakEffect()  
				Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function c1300070.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	e:GetHandler():RegisterFlagEffect(1300070,RESET_PHASE+PHASE_END,0,1)
end
function c1300070.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	e:GetHandler():ResetFlagEffect(1300070)
end
function c1300070.econ(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c1300070.elimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:IsActiveType(TYPE_MONSTER)
end
