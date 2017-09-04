--白咲学园
function c10950014.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10950014,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10950014.addct)
	e1:SetOperation(c10950014.addc)
	c:RegisterEffect(e1)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10950014,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c10950014.descon)
	e2:SetOperation(c10950014.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10950014,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(5,10950014)
	e4:SetCost(c10950014.cost)
	e4:SetTarget(c10950014.addct)
	e4:SetOperation(c10950014.addc2)
	c:RegisterEffect(e4)
end
function c10950014.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x13ac)
end
function c10950014.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x13ac,1)
	end
end
function c10950014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x13ac,3,REASON_COST)
end
function c10950014.addc2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x13ac,3)
	end
end
function c10950014.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetReasonPlayer()==1-tp
end
function c10950014.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10950014,0,0,0)
end