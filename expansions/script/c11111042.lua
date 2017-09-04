--银星之贤者 卡林
function c11111042.initial_effect(c)
	--special summon
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11111042)
	e1:SetCost(c11111042.spcost)
	e1:SetTarget(c11111042.sptg)
	e1:SetOperation(c11111042.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111042,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,111110420)
	e2:SetCondition(c11111042.setcon)
	e2:SetTarget(c11111042.settg)
	e2:SetOperation(c11111042.setop)
	c:RegisterEffect(e2)
end
function c11111042.cffilter(c)
	return c:IsSetCard(0x15d) and not c:IsCode(11111042) and not c:IsPublic() 
end
function c11111042.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111042.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11111042.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c11111042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11111042.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
	    local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCode(EVENT_PHASE+PHASE_END)
	    e1:SetOperation(c11111042.rmop)
	    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	    e1:SetCountLimit(1)
	    c:RegisterEffect(e1,true)
	end
end
function c11111042.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c11111042.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c11111042.setfilter1(c)
	return (c:IsCode(11111017) or c:IsCode(11111056)) and c:IsAbleToHand()
end
function c11111042.setfilter2(c)
	return (c:IsCode(11111018) or c:IsCode(11111046) or c:IsCode(11111051)) and c:IsSSetable()
end
function c11111042.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11111042.setfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c11111042.setfilter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(11111042,2),aux.Stringid(11111042,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(11111042,2))
	else op=Duel.SelectOption(tp,aux.Stringid(11111042,3))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end	
end
function c11111042.setop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	    local g=Duel.SelectMatchingCard(tp,c11111042.setfilter1,tp,LOCATION_DECK,0,1,1,nil)
	    if g:GetCount()>0 then
		    Duel.SendtoHand(g,nil,REASON_EFFECT)
		    Duel.ConfirmCards(1-tp,g)
	    end
	else	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c11111042.setfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end	
end