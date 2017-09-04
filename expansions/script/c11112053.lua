--耀转磁界 极龙
function c11112053.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x15b),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112053,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11112053)
	e1:SetCondition(c11112053.descon)
	e1:SetTarget(c11112053.destg)
	e1:SetOperation(c11112053.desop)
	c:RegisterEffect(e1)
	--tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112053,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,111120530)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c11112053.sptg)
	e2:SetOperation(c11112053.spop)
	c:RegisterEffect(e2)
end
function c11112053.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11112053.desfilter(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk) and c:IsDestructable()
end
function c11112053.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11112053.desfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_MZONE)
end
function c11112053.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c11112053.desfilter,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end 
end
function c11112053.tnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b) and (not c:IsType(TYPE_TUNER) or (c:IsType(TYPE_TUNER) and not c:IsHasEffect(EFFECT_NONTUNER)))
end
function c11112053.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11112053.tnfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2)
		and Duel.IsExistingTarget(c11112053.tnfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11112053.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112053.spfilter1(c,e,tp)
	return c:IsSetCard(0x15b) and c:IsLevelBelow(2) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c11112053.spfilter2(c,e,tp)
	return c:IsSetCard(0x15b) and c:IsLevelBelow(2) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c11112053.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,2,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if tc:IsType(TYPE_TUNER) and not tc:IsHasEffect(EFFECT_NONTUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(11112053,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_NONTUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local g1=Duel.GetMatchingGroup(c11112053.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11112053,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g1:Select(tp,1,1,nil)
			Duel.HintSelection(g2)
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end 
	elseif not tc:IsType(TYPE_TUNER) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
		local g3=Duel.GetMatchingGroup(c11112053.spfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
		if g3:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11112053,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g4=g3:Select(tp,1,1,nil)
			Duel.HintSelection(g4)
			Duel.SpecialSummon(g4,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
end