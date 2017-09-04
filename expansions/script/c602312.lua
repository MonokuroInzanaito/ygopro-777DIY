--星刻*拉寇尔四世
function c602312.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(602312,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,602312)
	e1:SetCondition(c602312.spcon)
	e1:SetOperation(c602312.spop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(602312,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c602312.shop)
	c:RegisterEffect(e2)

	--change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(602312,3))
	e6:SetCategory(CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c602312.cost)
	e6:SetCondition(c602312.condition)
	e6:SetTarget(c602312.target)
	e6:SetOperation(c602312.operation)
	c:RegisterEffect(e6)
	--change2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(602312,3))
	e7:SetCategory(CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,0x1c0+TIMING_BATTLE_PHASE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c602312.cost)
	e7:SetCondition(c602312.condition2)
	e7:SetTarget(c602312.target)
	e7:SetOperation(c602312.operation)
	c:RegisterEffect(e7)

	--can't XyzSummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end

function c602312.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x42c)
end

function c602312.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x42c) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_TOKEN)
end

function c602312.spcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c602312.spfilter1,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingMatchingCard(c602312.spfilter2,tp,LOCATION_ONFIELD,0,2,nil)
end

function c602312.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c602312.spfilter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c602312.spop2)
	c:RegisterEffect(e1)
end

function c602312.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,c602312.spfilter2,tp,LOCATION_ONFIELD,0,2,2,nil)
	if g2:GetCount()==2 then 
		Duel.Overlay(e:GetHandler(),g2)
	else Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end
end

function c602312.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x42c) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c602312.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c602312.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(602301) and not c:IsDisabled() and not c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)
end

function c602312.condition(e,c)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x623)
		and not Duel.IsExistingMatchingCard(c602312.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602312.condition2(e,c)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x42c)
		and Duel.IsExistingMatchingCard(c602312.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602312.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(602312)==0 end
	e:GetHandler():RegisterFlagEffect(602312,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c602312.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x42c)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end

