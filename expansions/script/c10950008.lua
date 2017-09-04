--GhostChild
function c10950008.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10950008.spcon)
	e0:SetOperation(c10950008.spop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetOperation(c10950008.chainop)
	c:RegisterEffect(e4)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10950008,2))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetTarget(c10950008.target2)
	e9:SetOperation(c10950008.operation2)
	c:RegisterEffect(e9)
end
function c10950008.spfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x231) and c:IsAbleToGraveAsCost()
end
function c10950008.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x231)
end
function c10950008.syc(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x13ac,5,REASON_COST)
end
function c10950008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()   
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 
	and Duel.IsExistingMatchingCard(c10950008.spfilter2,tp,LOCATION_MZONE,0,3,nil) then 
	return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,5,REASON_COST) and Duel.IsExistingMatchingCard(c10950008.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
	end
end
function c10950008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10950008.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.RemoveCounter(tp,1,0,0x13ac,5,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST) 
end
function c10950008.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10950008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10950008.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c10950008.chainop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end