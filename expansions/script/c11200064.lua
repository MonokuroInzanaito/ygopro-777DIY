--幸运的白兔 因幡帝
function c11200064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetOperation(c11200064.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(11200064,1))
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11200064)
	e2:SetCondition(c11200064.condition)
	e2:SetCost(c11200064.cost)
	e2:SetTarget(c11200064.target)
	e2:SetOperation(c11200064.operation)
	c:RegisterEffect(e2) 
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c11200064.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c11200064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(11200064)~=0 end
end
function c11200064.spfilter(c,e,tp)
	return c:IsCode(11200065) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsExistingMatchingCard(c11200064.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c11200064.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	local g=Duel.GetMatchingGroup(c11200064.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local t=Duel.IsPlayerCanDraw(tp,1)
	local op=0
	if g:GetCount()>0 and t then
	   op=Duel.SelectOption(tp,aux.Stringid(11200064,2),aux.Stringid(11200064,3))
	elseif g:GetCount()>0 and not t then
	   op=0
	else op=1
	end
	Duel.BreakEffect()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11200064.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c11200064.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(11200064)~=0 then return end
	if not c:IsPreviousLocation(LOCATION_DECK) then return end
	if (c:IsReason(REASON_DRAW) and Duel.GetTurnPlayer()==tp and c:IsReason(REASON_RULE)) or c:IsReason(REASON_EFFECT) then
	  if Duel.SelectYesNo(tp,aux.Stringid(11200064,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(11200064,RESET_PHASE+PHASE_MAIN1,0,1)
	  end
	end
end