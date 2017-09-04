--独舞
function c10981055.initial_effect(c)
	c:SetUniqueOnField(1,1,10981055)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10981055,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(c10981055.cost)
	e2:SetCondition(c10981055.negcon)
	e2:SetTarget(c10981055.negtg)
	e2:SetOperation(c10981055.negop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c10981055.negcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c10981055.mtop)
	c:RegisterEffect(e4)	
end
function c10981055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10981055)==0 end
	c:RegisterFlagEffect(10981055,RESET_CHAIN,0,1)
end
function c10981055.negcon(e,tp,eg,ep,ev,re,r,rp)
    return (re:GetActivateLocation()==LOCATION_HAND and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) or re:GetActivateLocation()==LOCATION_GRAVE
	or re:GetActivateLocation()==LOCATION_REMOVED 
	and Duel.IsChainNegatable(ev)
end
function c10981055.negcon2(e,tp,eg,ep,ev,re,r,rp)
    return re:GetActivateLocation()==LOCATION_DECK or re:GetActivateLocation()==LOCATION_EXTRA and Duel.IsChainNegatable(ev)
end
function c10981055.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10981055.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end
function c10981055.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
