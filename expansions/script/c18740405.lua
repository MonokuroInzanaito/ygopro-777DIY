--狂猎 阿拉溫
function c18740405.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55885348,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c18740405.target)
	e1:SetOperation(c18740405.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18740401,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CVAL_CHECK)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,18740405)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c18740405.spcon)
	e4:SetCost(c18740405.cost)
	e4:SetTarget(c18740405.sptg)
	e4:SetOperation(c18740405.spop)
	e4:SetValue(c18740405.valcheck)
	c:RegisterEffect(e4)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(18740401,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CVAL_CHECK)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,18740405)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c18740405.spcon2)
	e4:SetCost(c18740405.cost)
	e4:SetTarget(c18740405.sptg)
	e4:SetOperation(c18740405.spop)
	e4:SetValue(c18740405.valcheck)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(18740405,ACTIVITY_SPSUMMON,c18740405.counterfilter)
end
function c18740405.counterfilter(c)
	return c:IsSetCard(0xab5)
end
function c18740405.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	local ct=g:GetCount()
	e:SetLabel(ct)
end
function c18740405.filter2(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xab5) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c18740405.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local lv=og:GetSum(Card.GetLevel)
	Duel.BreakEffect()
	if lv>9 and Duel.SelectYesNo(tp,aux.Stringid(18740405,2)) then
	if not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
	local tc=Duel.SelectMatchingCard(tp,c18740405.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=tc:GetFirst()
	if sc then
		local cg=Group.FromCards(c)
		sc:SetMaterial(cg)
		Duel.Overlay(sc,cg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	end
end
function c18740405.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp and c:IsLocation(LOCATION_GRAVE)
end
function c18740405.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18740405.spfilter,1,nil,tp)
end
function c18740405.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18740405.spfilter,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,18740410)
end
function c18740405.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then if Duel.GetFlagEffect(tp,18740402)==0 then
			Duel.RegisterFlagEffect(tp,18740402,RESET_CHAIN,0,1)
			c18740402[0]=eg:Filter(c18740405.spfilter,nil,tp):GetCount()
			c18740402[1]=0
		end return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.GetCustomActivityCount(18740405,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and c18740402[0]-c18740402[1]>=1
		and eg:IsExists(c18740405.spfilter,1,nil,tp) end
		local g=eg:Filter(c18740405.spfilter,nil,tp)
		if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		end
end
function c18740405.valcheck(e)
	c18740402[1]=c18740402[1]+60
end
function c18740405.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then if Duel.GetFlagEffect(tp,18740401)==0 then
			Duel.RegisterFlagEffect(tp,18740401,RESET_CHAIN,0,1)
			c18740401[0]=eg:Filter(c18740405.spfilter,nil,tp):GetCount()
			c18740401[1]=0
		end return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(c18740405.chlimit)
end
function c18740405.chlimit(e,ep,tp)
	local c=e:GetHandler()
	return not c:IsSetCard(0xab5) and not c:IsType(TYPE_XYZ)
end
function c18740405.otfilter(c)
	return (bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE or bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL) and not c:IsSetCard(0xab5)
end
function c18740405.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	local mg=Duel.GetMatchingGroup(c18740405.otfilter,tp,LOCATION_MZONE,0,nil)
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
	e1:SetTarget(c18740405.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c18740405.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xab5)
end