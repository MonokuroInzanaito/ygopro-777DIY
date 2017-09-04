--天印-赤飚怒
function c91000016.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000016,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xe10)
	end)
	e1:SetCost(c91000016.imcost)
	e1:SetOperation(c91000016.imop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c)
		return c:IsType(TYPE_XYZ) and c:GetOriginalRank()==2
	end)
	e2:SetValue(function(e,c)
		local ec=e:GetHandler()
		local code=ec:GetOriginalCode()*2+1
		if ec:GetFlagEffect(code)>0 then 
			return ec:GetFlagEffectLabel(code)*500
		else return 0 end
	end)
	c:RegisterEffect(e2)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c91000016.rop)
	c:RegisterEffect(e3)
end
function c91000016.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(91000016)==0 then
		local code=c:GetOriginalCode()*2+1
		local ct=c:GetOverlayCount()
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c91000016.reop)
		e1:SetLabel(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		c:RegisterFlagEffect(91000016,RESET_EVENT+0x1fe0000,0,1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1,0)
	end
end
function c91000016.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=e:GetLabel()
	local ct2=c:GetOverlayCount()
	if ct1==ct2 then return end
	if ct1>ct2 then
		local ct=ct1-ct2
		local code=c:GetOriginalCode()*2+1
		local lt=c:GetFlagEffectLabel(code)
		c:SetFlagEffectLabel(code,lt+ct)
	end
	e:SetLabel(ct2)
	Duel.Readjust()
end
function c91000016.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function c91000016.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c91000016.etg)
		e1:SetValue(c91000016.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c91000016.etg(e,c)
	if c:IsType(TYPE_XYZ) then
		return c:GetOriginalRank()==2
	else
		return c:GetOriginalLevel()==2
	end
end
function c91000016.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
