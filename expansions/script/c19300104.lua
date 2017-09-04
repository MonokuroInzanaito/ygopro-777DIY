--镜现诗·浅蓝色的月兔
function c19300104.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,19300104)
	e1:SetCondition(c19300104.condition)
	e1:SetCost(c19300104.cost)
	e1:SetTarget(c19300104.target)
	e1:SetOperation(c19300104.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(19300104,ACTIVITY_SPSUMMON,c19300104.counterfilter)
end
function c19300104.counterfilter(c)
	return c:IsSetCard(0x193)
end
function c19300104.filter1(c)
	return c:IsSetCard(0x193) and c:GetLevel()==2 and c:GetCode()~=19300104
end
function c19300104.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19300104.filter1,1,nil)
end
function c19300104.cffilter(c)
	return c:IsSetCard(0x193) and c:GetCode()~=19300104 and not c:IsPublic()
end
function c19300104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300104.cffilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetCustomActivityCount(19300104,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300104.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c19300104.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c19300104.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x193)
end
function c19300104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c19300104.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end