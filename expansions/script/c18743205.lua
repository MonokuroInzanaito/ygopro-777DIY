--高达DX
function c18743205.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4335427,0))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c18743205.rmop)
	c:RegisterEffect(e4)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(95503687,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c18743205.discon)
	e2:SetTarget(c18743205.distg)
	e2:SetOperation(c18743205.disop)
	c:RegisterEffect(e2)
end
os=require("os")
function c18743205.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(0,5))
	Duel.SelectOption(tp,aux.Stringid(18743205,val))
	Duel.SelectOption(1-tp,aux.Stringid(18743205,val))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c18743205.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c18743205.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c18743205.limit)
end
function c18743205.limit(e,ep,tp)
	return tp==ep
end
function c18743205.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(6,7))
	Duel.SelectOption(tp,aux.Stringid(18743205,val))
	Duel.SelectOption(1-tp,aux.Stringid(18743205,val))
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
