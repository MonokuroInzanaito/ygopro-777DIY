--激昂兽王 金狮子
function c11112054.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x15b),1)
	c:EnableReviveLimit()
	--mill
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11112054.sumcon)
	e1:SetOperation(c11112054.sumsuc)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112054,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11112054)
	e2:SetCondition(c11112054.actcon)
	e2:SetTarget(c11112054.acttg)
	e2:SetOperation(c11112054.actop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,111120540)
	e3:SetCondition(c11112054.atkcon)
	e3:SetTarget(c11112054.atktg)
	e3:SetOperation(c11112054.atkop)
	c:RegisterEffect(e3)
end
function c11112054.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11112054.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11112054,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c11112054.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11112054)~=0
end
function c11112054.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c11112054.chainlm)
end
function c11112054.chainlm(e,rp,tp)
	return tp==rp
end
function c11112054.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function c11112054.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c11112054.atkfilter(c)
	return c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER)
end
function c11112054.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(111120540)==0
	    and Duel.IsPlayerCanDiscardDeck(tp,2)
		and Duel.IsExistingMatchingCard(c11112054.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(111120540,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11112054.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.DiscardDeck(tp,2,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	    local ct=Duel.GetMatchingGroupCount(c11112054.atkfilter,tp,LOCATION_GRAVE,0,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*100)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(c11112054.rdcon)
		e2:SetOperation(c11112054.rdop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		Duel.RegisterEffect(e2,tp)
	end
end
function c11112054.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c11112054.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end