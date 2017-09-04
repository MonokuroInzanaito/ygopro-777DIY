--夜魅
function c500000.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,500000)
	e2:SetCondition(c500000.sprcon)
	e2:SetOperation(c500000.sprop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500000,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_START)
	e3:SetCondition(c500000.spcon)
	e3:SetCost(c500000.spcost)
	e3:SetTarget(c500000.sptg)
	e3:SetOperation(c500000.spop)
	c:RegisterEffect(e3) 
	
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	--tofield
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500000,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,500100)
	e4:SetTarget(c500000.tftg)
	e4:SetOperation(c500000.tfop)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCategory(0)
	e5:SetDescription(aux.Stringid(500000,2))
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(c500000.thtg)
	e5:SetOperation(c500000.thop) 
	c:RegisterEffect(e5) 
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(500000,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e6:SetCondition(c500000.spcon1)
	e6:SetCost(c500000.spcos1t)
	e6:SetTarget(c500000.sptg1)
	e6:SetOperation(c500000.spop1)
	c:RegisterEffect(e6) 
end
function c500000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500000.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_EXTRA)
end
function c500000.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function c500000.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500000.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) and not c:IsForbidden() and  (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.SelectYesNo(tp,aux.Stringid(500000,4)) then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c500000.tfop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c500000.tffilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 and e:GetHandler():IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(500000,3)) then
	   Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c500000.tffilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c500000.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c500000.tffilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c500000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ((ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c500000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c500000.sprfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c500000.sprfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c500000.sprfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c500000.sprfilter,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c500000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and e:GetHandler():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c500000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c500000.sprfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_MZONE) or c:GetSequence()>5)
end
function c500000.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c500000.sprfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c500000.sprfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c500000.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c500000.sprfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c500000.sprfilter,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c500000.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ((ph==PHASE_BATTLE_START or ph==PHASE_BATTLE) and Duel.GetTurnPlayer()==tp) or (ph>=PHASE_MAIN1 and ph<=PHASE_MAIN2)
end
function c500000.spcos1t(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c500000.sprfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c500000.sprfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c500000.sprfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c500000.sprfilter,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c500000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and e:GetHandler():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c500000.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end