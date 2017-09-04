--次元的魔女 朵萝西
function c18706084.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c18706084.remcon)
	e1:SetOperation(c18706084.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18706084,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c18706084.con)
	e2:SetTarget(c18706084.target)
	e2:SetOperation(c18706084.operation)
	c:RegisterEffect(e2) 
end
function c18706084.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO or re:GetHandler():IsSetCard(0xabb)
end
function c18706084.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(18706084,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c18706084.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(18706084)~=0
end
function c18706084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c18706084.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()>0 then Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) end
	Duel.BreakEffect()
	Duel.Draw(tp,5,REASON_EFFECT)
end