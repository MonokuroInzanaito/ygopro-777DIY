--传说之狂战士 清姫
function c99998958.initial_effect(c)
	c:SetUniqueOnField(1,1,99998958)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99998958.splimit)
	c:RegisterEffect(e1)
	--转身火生三昧
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99991096,9))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c99998958.tg)
	e2:SetOperation(c99998958.op)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c99998958.becon)
	c:RegisterEffect(e4)
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27346636,1))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c99998958.sprcon)
	e5:SetOperation(c99998958.sprop)
	c:RegisterEffect(e5)
end
function c99998958.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c99998958.becon(e)
	return e:GetHandler():IsAttackable()
end
function c99998958.spfilter1(c,tp,fc)
	return (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c99998958.spfilter2,tp,LOCATION_MZONE,0,1,c,fc)
end
function c99998958.spfilter2(c,fc)
	return c:IsRace(RACE_DRAGON)  and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
	and (c:IsLevelAbove(7) or c:IsRankAbove(4))
end
function c99998958.spfilter3(c)
	return c:IsType(TYPE_EQUIP)  and c:IsAbleToGraveAsCost()
end
function c99998958.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c99998958.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
		and Duel.IsExistingMatchingCard(c99998958.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c99998958.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c99998958.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c99998958.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local g3=Duel.SelectMatchingCard(tp,c99998958.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c99998958.desfilter(c)
	return c:IsControlerCanBeChanged() or c:IsDestructable()
end
function c99998958.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998958.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c99998958.op(e,tp,eg,ep,ev,re,r,rp)
    local op=Duel.SelectOption(1-tp,aux.Stringid(99991096,10),aux.Stringid(99991096,11))
	if op==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,1-tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	else
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,1-tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(c99998958.costchk)
	e1:SetOperation(c99998958.costop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c99998958.costchk)
	e2:SetTarget(c99998958.costtg)
	e2:SetOperation(c99998958.costop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c99998958.turncon)
	e4:SetOperation(c99998958.turnop)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	Duel.RegisterEffect(e4,tp)
	e4:SetLabelObject(e)
	c99998958[e:GetHandler()]=e4
end
end
end
function c99998958.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c99998958.costtg(e,te,tp)
	return  te:GetHandler():IsLocation(LOCATION_MZONE)
end
function c99998958.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c99998958.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c99998958.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==5 then
		e:GetLabelObject():Reset()
	end
end