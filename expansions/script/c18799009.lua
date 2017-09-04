--聖殿騎士
function c18799009.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),aux.NonTuner(Card.IsSetCard,0xab0),1)
	c:EnableReviveLimit()
	--selfdes
	--local e7=Effect.CreateEffect(c)
	--e7:SetType(EFFECT_TYPE_SINGLE)
	--e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e7:SetRange(LOCATION_MZONE)
	--e7:SetCode(EFFECT_SELF_DESTROY)
	--e7:SetCondition(c18799009.descon)
	--c:RegisterEffect(e7)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_SZONE,0)
	e9:SetTarget(c18799009.indes)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28637168,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c18799009.tg)
	e1:SetOperation(c18799009.op)
	c:RegisterEffect(e1)
	--level change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36088082,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c18799009.regcon)
	e1:SetTarget(c18799009.regtg)
	e1:SetOperation(c18799009.regop)
	c:RegisterEffect(e1)
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18799009.efilter)
	c:RegisterEffect(e1)
end
function c18799009.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c18799009.indes(e,c)
	return c:IsFaceup() and c:IsCode(18799010)
end
function c18799009.descon(e)
	return not Duel.IsExistingMatchingCard(c18799009.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c18799009.filter(c)
	return c:IsCode(18799010) and c:IsFaceup()
end
function c18799009.afilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsCode(18799009)
end
function c18799009.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18799009.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c18799009.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c18799009.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18799009.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c18799009.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget() 
	and Duel.GetAttackTarget():IsDefensePos() and Duel.GetAttackTarget():IsAbleToRemove()
end
function c18799009.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() and t:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,t,1,0,0)
end
function c18799009.regop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() and not t:IsAttackPos() then
	Duel.Remove(t,POS_FACEDOWN,REASON_EFFECT)
	end
end