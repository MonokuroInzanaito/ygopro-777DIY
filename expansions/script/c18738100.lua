--黑圣女 龙音闇
function c18738100.initial_effect(c)
	c:SetSPSummonOnce(18738100)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x3ab0),2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c18738100.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c18738100.spcon)
	e2:SetOperation(c18738100.spop)
	c:RegisterEffect(e2)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54719828,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18738100)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c18738100.target)
	e1:SetOperation(c18738100.operation)
	c:RegisterEffect(e1)
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c18738100.condition)
	e2:SetCost(c18738100.necost)
	e2:SetTarget(c18738100.netg)
	e2:SetOperation(c18738100.neop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c18738100.thcon)
	e3:SetTarget(c18738100.thtg)
	e3:SetOperation(c18738100.thop)
	c:RegisterEffect(e3)
end
function c18738100.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c18738100.spfilter1(c,tp,fc)
	return c:IsSetCard(0x3ab0) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c18738100.spfilter2,1,c,fc)
end
function c18738100.spfilter2(c,fc)
	return c:IsSetCard(0x3ab0) and c:IsCanBeFusionMaterial(fc)
end
function c18738100.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c18738100.spfilter1,1,nil,tp,c)
end
function c18738100.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c18738100.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c18738100.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c18738100.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c18738100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(54719828,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function c18738100.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	e:GetHandler():RegisterFlagEffect(333331,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,0)
	elseif e:GetLabel()==1 then
	e:GetHandler():RegisterFlagEffect(333332,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,0)
	else e:GetHandler():RegisterFlagEffect(333333,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,0) end
	if e:GetHandler():GetFlagEffect(333331)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(18738100,0))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e:GetHandler():RegisterEffect(e2)
	end
	if e:GetHandler():GetFlagEffect(333332)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(18738100,1))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e:GetHandler():RegisterEffect(e2)
	end
	if e:GetHandler():GetFlagEffect(333333)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(18738100,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e:GetHandler():RegisterEffect(e2)
	end
end
function c18738100.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(333331)>0 then
	return rp~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
	elseif c:GetFlagEffect(333332)>0 then
	return rp~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL)
	elseif c:GetFlagEffect(333333)>0 then
	return rp~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_TRAP)
	end
end 
function c18738100.cfilter(c)
	return c:IsSetCard(0x3ab0) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c18738100.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738100.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738100.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c18738100.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
   -- if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
   --   Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
   -- end
end
function c18738100.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
   -- if re:GetHandler():IsRelateToEffect(re) then
	   -- Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
  --  end
end
function c18738100.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c18738100.thfilter(c)
	return c:IsSetCard(0x3ab0) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c18738100.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18738100.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18738100.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c18738100.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c18738100.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end