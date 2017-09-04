--烙印之子 克里斯
function c602208.initial_effect(c)
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsSetCard,0x622),2,true,true)
	c:EnableReviveLimit()
	--can't Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(602208,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END+TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,60220801)
	e2:SetCondition(c602208.condition1)
	e2:SetTarget(c602208.target1)
	e2:SetOperation(c602208.activate1)
	c:RegisterEffect(e2)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(602208,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_BATTLE_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,60220802)
	e3:SetTarget(c602208.tg)
	e3:SetOperation(c602208.op)
	c:RegisterEffect(e3)
	--Change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(602208,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_CHANGE_POS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c602208.target2)
	e4:SetOperation(c602208.activate2)
	c:RegisterEffect(e4)
end
function c602208.filter1(c,e)
	return  c:IsSetCard(0x622) and c:IsAbleToGrave()
--  and not c:IsImmuneToEffect(e)
end
function c602208.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2))
		 or (Duel.GetTurnPlayer()~=tp and ph==PHASE_BATTLE)
end
function c602208.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		 and Duel.IsExistingMatchingCard(c602208.filter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,nil) end
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c602208.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c602208.filter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,nil)
	local c=e:GetHandler() 
	if g:GetCount()>1 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	   c:SetMaterial(g)
	   Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
	   c:CompleteProcedure()
	end
end
function c602208.filter2(c,e)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c602208.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c602208.filter2,tp,LOCATION_MZONE,LOCATION_MZON,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c602208.filter2,tp,LOCATION_MZONE,LOCATION_MZON,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c602208.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and e:GetHandler():IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end
end
function c602208.filter3(c,e,tp)
	return c:IsCode(602207) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c602208.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c602208.activate2(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c602208.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c602208.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	if not Duel.IsExistingMatchingCard(c602208.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
	local field=Duel.CreateToken(tp,602207)
	Duel.MoveToField(field,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
	end
end