--
function c29200020.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),10,2)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200020,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c29200020.spcon)
	e2:SetTarget(c29200020.sptg)
	e2:SetOperation(c29200020.spop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c29200020.thcost)
	e3:SetTarget(c29200020.thtg)
	e3:SetOperation(c29200020.thop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c29200020.condition)
	e4:SetValue(c29200020.efilter)
	c:RegisterEffect(e4)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c29200020.condition1)
	e5:SetOperation(c29200020.handes)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
function c29200020.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()~=tp
end
function c29200020.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29200020.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler()) and c29200020.condition(e,tp,eg,ep,ev,re,r,rp)
end
function c29200020.filter1(c)
	return not c:IsPublic()
end
function c29200020.filter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()~=tp and c:IsRelateToEffect(e)
end
function c29200020.handes(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(c29200020.filter1,tp,0,LOCATION_HAND,nil)
	if cg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(29200020,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local sg=cg:Select(1-tp,1,1,nil)
			--Duel.ConfirmCards(tp,sg)
			local tc=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			Duel.ShuffleHand(1-tp)
			Duel.BreakEffect()
	else 
			local tc=eg:GetFirst()
			while tc do
				if tc:IsFaceup() and tc:GetSummonPlayer()~=tp then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e2)
			end
				tc=eg:GetNext()
			end
	end
end
function c29200020.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29200020.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29200020.desfilter1(c,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()~=lv and not c:IsType(TYPE_XYZ) and c:IsAbleToGrave()
end
function c29200020.desfilter2(c,lv)
	return c:IsType(TYPE_XYZ) and c:GetRank()~=lv and c:IsAbleToGrave()
end
function c29200020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function c29200020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.GetMatchingGroup(c29200020.thfilter,1-tp,LOCATION_DECK,0,nil)
	local g=g1:Select(1-tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		local lv=tc:GetLevel()
		e:SetLabel(lv)
		local g2=Duel.GetMatchingGroup(c29200020.desfilter1,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetLevel())
		local g3=Duel.GetMatchingGroup(c29200020.desfilter2,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetLevel())
		g2:Merge(g3)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleDeck(1-tp)
	end
end
function c29200020.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c29200020.spfilter2(c,e,tp)
	return c:IsSetCard(0x33e0) and not c:IsCode(29200020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29200020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29200020.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29200020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29200020.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29200020.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c29200020.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c29200020.filter,1,nil)
end
function c29200020.efilter(e,re,rp)
    if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    return not g:IsContains(e:GetHandler())
end 