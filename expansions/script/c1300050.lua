--虚拟歌姬 紧依卫
function c1300050.initial_effect(c)
	c:SetSPSummonOnce(1300050)
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
--  e1:SetDescription(aux.Stringid(1300050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c1300050.spcon)
	e1:SetTarget(c1300050.sptg)
	e1:SetOperation(c1300050.spop)
	c:RegisterEffect(e1)
	--indes
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetTargetRange(LOCATION_ONFIELD,0)
	e2_1:SetTarget(c1300050.indtg)
	e2_1:SetValue(1)
	c:RegisterEffect(e2_1)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2_2)
end
function c1300050.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function c1300050.spfilter(c,player)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()==1300000 and c:GetPreviousControler()==player
end
function c1300050.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1300050.spfilter,1,nil,tp)
end
function c1300050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsFaceup()-- and Duel.GetFlagEffect(tp,1300000)~=0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
--  e:GetHandler():RegisterFlagEffect(1300050,RESET_PHASE+PHASE_END,0,1)
end
function c1300050.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
		if Duel.SelectYesNo(tp,aux.Stringid(1300050,0)) then 
			Duel.BreakEffect()
			Duel.SetLP(tp,4000) 
		end
	end
end
function c1300050.indtg(e,c)
	return c:IsSetCard(0x130) and c~=e:GetHandler()
end
