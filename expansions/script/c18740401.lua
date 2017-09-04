--狂猎 黑卡蒂
function c18740401.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55885348,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c18740401.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18740401,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CVAL_CHECK)
	e4:SetCountLimit(1,18740401)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c18740401.spcon)
	e4:SetCost(c18740401.cost)
	e4:SetTarget(c18740401.sptg)
	e4:SetOperation(c18740401.spop)
	e4:SetValue(c18740401.valcheck)
	c:RegisterEffect(e4)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18740401,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CVAL_CHECK)
	e4:SetCountLimit(1,18740401)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c18740401.spcon2)
	e4:SetCost(c18740401.cost)
	e4:SetTarget(c18740401.sptg)
	e4:SetOperation(c18740401.spop)
	e4:SetValue(c18740401.valcheck)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(18740401,ACTIVITY_SPSUMMON,c18740401.counterfilter)
end
function c18740401.counterfilter(c)
	return c:IsSetCard(0xab5)
end
function c18740401.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab5) and c:IsAbleToHand()
end
function c18740401.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_DECK,nil,TYPE_SPELL+TYPE_TRAP)
	local dcount=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(1-tp,dcount)
		Duel.ShuffleDeck(1-tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(1-tp,dcount-seq)
	if  Duel.DiscardDeck(1-tp,dcount-seq,REASON_EFFECT+REASON_REVEAL)>0 then
		local og=Duel.GetOperatedGroup()
		local lv=og:GetSum(Card.GetLevel)
		if lv>9 and Duel.SelectYesNo(tp,aux.Stringid(18740401,0)) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c18740401.filter,tp,LOCATION_ONFIELD,0,1,99,nil)
		if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	end
	end
end
function c18740401.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp and c:IsLocation(LOCATION_GRAVE)
end
function c18740401.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18740401.spfilter,1,nil,tp)
end
function c18740401.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18740401.spfilter,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,18740410)
end
function c18740401.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,18740402)==0 then
			Duel.RegisterFlagEffect(tp,18740402,RESET_CHAIN,0,1)
			c18740402[0]=eg:Filter(c18740401.spfilter,nil,tp):GetCount()
			c18740402[1]=0
		end return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.GetCustomActivityCount(18740401,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c18740402[0]-c18740402[1]>=1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and eg:IsExists(c18740401.spfilter,1,nil,tp) end
		local g=eg:Filter(c18740401.spfilter,nil,tp)
		if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		end
end
function c18740401.valcheck(e)
	c18740402[1]=c18740402[1]+60
end
function c18740401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18740401.otfilter(c)
	return (bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE or bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL) and not c:IsSetCard(0xab5)
end
function c18740401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	local mg=Duel.GetMatchingGroup(c18740401.otfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(mg,REASON_EFFECT)
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		if Duel.GetTurnPlayer()~=tp then
			e1:SetReset(RESET_PHASE+PHASE_END,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END,1)
		end
	e1:SetTargetRange(1,0)
	e1:SetTarget(c18740401.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c18740401.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xab5)
end