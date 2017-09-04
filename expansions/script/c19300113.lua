--镜现诗·传统的幻想书屋
function c19300113.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(c19300113.condition)
	e1:SetCost(c19300113.cost)
	e1:SetTarget(c19300113.target)
	e1:SetOperation(c19300113.operation)
	c:RegisterEffect(e1)
end
function c19300113.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return ph==PHASE_BATTLE
	end
end
function c19300113.cffilter(c,e,tp)
	return c:IsSetCard(0x193) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=19300113 and not c:IsPublic()
end
function c19300113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300113.cffilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and e:GetHandler():GetFlagEffect(19300113)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300113.cffilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
	e:GetHandler():RegisterFlagEffect(19300113,RESET_CHAIN,0,1)
end
function c19300113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	e:SetLabelObject(tc)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or e:GetHandler():IsLocation(LOCATION_MZONE))
		and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c19300113.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_HAND) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end