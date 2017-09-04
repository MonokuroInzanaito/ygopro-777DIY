--约定好的再重逢
function c10985010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10985010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c10985010.condition)
	e1:SetTarget(c10985010.target)
	e1:SetOperation(c10985010.operation)
	c:RegisterEffect(e1)	
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10985010,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c10985010.condition2)
	e4:SetTarget(c10985010.target2)
	e4:SetOperation(c10985010.operation2)
	c:RegisterEffect(e4)	
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5) 
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e6:SetValue(LOCATION_REMOVED)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e6)   
end
function c10985010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and not (Duel.GetFlagEffect(tp,10985000)~=0 and Duel.GetFlagEffect(tp,10985001)~=0 and Duel.GetFlagEffect(tp,10985002)~=0 and Duel.GetFlagEffect(tp,10985003)~=0 and Duel.GetFlagEffect(tp,10985004)~=0 and Duel.GetFlagEffect(tp,10985005)~=0 and Duel.GetFlagEffect(tp,10985009)~=0)
end
function c10985010.filter(c,e,tp)
	return c:IsCode(10985006) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10985010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10985010.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function c10985010.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10985010.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10985010.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10985000)~=0 and Duel.GetFlagEffect(tp,10985001)~=0 and Duel.GetFlagEffect(tp,10985002)~=0 and Duel.GetFlagEffect(tp,10985003)~=0 and Duel.GetFlagEffect(tp,10985004)~=0 and Duel.GetFlagEffect(tp,10985005)~=0 and Duel.GetFlagEffect(tp,10985009)~=0
end
function c10985010.filter2(c,e,tp)
	return c:IsCode(10985005) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10985010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10985010.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function c10985010.filter3(c)
	return c:IsAbleToHand()
end
function c10985010.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c10985010.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c10985010.filter3,tp,LOCATION_REMOVED,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end

