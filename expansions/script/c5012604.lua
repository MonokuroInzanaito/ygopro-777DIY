--上条当麻
function c5012604.initial_effect(c)
	c:SetUniqueOnField(1,1,5012604)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c5012604.sfliter),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c5012604.op)
	c:RegisterEffect(e1)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x350)
	c:RegisterEffect(e2)
	local e10=e2:Clone()
	e10:SetValue(0x23c)
	c:RegisterEffect(e10)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5012604,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c5012604.discon)
	e3:SetTarget(c5012604.distg)
	e3:SetOperation(c5012604.disop)
	c:RegisterEffect(e3)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	--sp
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5012604,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e5:SetCondition(c5012604.spcon)
	e5:SetTarget(c5012604.sptg)
	e5:SetOperation(c5012604.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c5012604.spcon2)
	e6:SetTarget(c5012604.sptg2)
	e6:SetOperation(c5012604.spop2)
	c:RegisterEffect(e6)
	--attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SET_ATTACK)
	e7:SetCondition(c5012604.condtion)
	e7:SetValue(c5012604.val)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e8:SetCondition(c5012604.damcon)
	e8:SetOperation(c5012604.damop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCondition(c5012604.damcon2)
	e9:SetOperation(c5012604.damop2)
	c:RegisterEffect(e9)
end
function c5012604.sfliter(c)
	return c:IsSetCard(0x350) or c:IsSetCard(0x23c)
end
function c5012604.op(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
	end
end
function c5012604.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
	and re:GetHandler()~=e:GetHandler() and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c5012604.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c5012604.disop(e,tp,eg,ep,ev,re,r,rp)
	if  e:GetHandler():IsDefensePos() then return end
	if Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENCE) then
	Duel.NegateActivation(ev)
	end
end
function c5012604.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and (at:IsSetCard(0x350) or at:IsSetCard(0x23c) ) and at:IsAbleToHand() 
end
function c5012604.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and  e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,at,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c5012604.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local at=Duel.GetAttackTarget()
	if at and Duel.SendtoHand(at,nil,REASON_EFFECT)>0 
	and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		e:GetHandler():RegisterFlagEffect(5012604,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c5012604.tdcon)
		e1:SetOperation(c5012604.tdop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c5012604.tdcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(5012604)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c5012604.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c5012604.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and(c:IsSetCard(0x350) or c:IsSetCard(0x23c) ) and c:IsAbleToHand() 
	and c:IsType(TYPE_MONSTER)
end
function c5012604.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c5012604.filter,1,nil,tp)
end
function c5012604.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-5
		and  e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:Filter(c5012604.filter,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,tc:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c5012604.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-5 then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:Filter(c5012604.filter,nil,tp)
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 
	and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		e:GetHandler():RegisterFlagEffect(5012604,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c5012604.tdcon)
		e1:SetOperation(c5012604.tdop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c5012604.condtion(e,c)
	 local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and  Duel.GetAttacker()==e:GetHandler()
	 and e:GetHandler():GetBattleTarget()==nil and  Duel.GetLP(e:GetHandler():GetControler())<Duel.GetLP(1-e:GetHandler():GetControler())
end
function c5012604.val(e,c)
	local g1=e:GetHandler():GetControler()
	local g2=1-g1
	return Duel.GetLP(g2)-Duel.GetLP(g1)
end
function c5012604.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
	and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil   and  Duel.GetLP(tp)==Duel.GetLP(1-tp)
end
function c5012604.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c5012604.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
	and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil  and  Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c5012604.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end