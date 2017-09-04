--镜现诗·橘色的月兔
function c19300103.initial_effect(c)
	c:EnableCounterPermit(0x1933)
	c:SetCounterLimit(0x1933,5)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c19300103.spcon)
	c:RegisterEffect(e1)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c19300103.acop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c19300103.spcost)
	e3:SetOperation(c19300103.spop)
	c:RegisterEffect(e3)
end
function c19300103.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x193) and c:GetLevel()==2
end
function c19300103.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19300103.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19300103.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x193) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1933,1)
	end
end
function c19300103.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1933,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1933,5,REASON_COST)
end
function c19300103.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsFaceup() then return end
	--change base attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,2)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(3000)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c19300103.efilter)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e:GetHandler():RegisterEffect(e2)
end
function c19300103.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end