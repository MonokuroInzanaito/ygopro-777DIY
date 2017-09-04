--亿万分之一的希望
function c10910007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10910007,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10910007.cost)
	e1:SetTarget(c10910007.pctg)
	e1:SetOperation(c10910007.pcop)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10910007,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c10910007.condition)
	e2:SetTarget(c10910007.pctg)
	e2:SetOperation(c10910007.pcop)
	c:RegisterEffect(e2)
end
function c10910007.filter0(c)
	return c:IsFaceup() and c:IsCode(5012613)
end
function c10910007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10910007.filter0,tp,LOCATION_MZONE,0,1,nil)
end
function c10910007.filter(c)
	return c:IsSetCard(0x350) and c:IsAbleToGraveAsCost()
end
function c10910007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10910007.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,4,e:GetHandler()) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10910007.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,4,4,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c10910007.pcfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x350) and not c:IsForbidden()
end
function c10910007.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c10910007.pcfilter2,tp,LOCATION_EXTRA,0,1,nil) end
end
function c10910007.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10910007.pcfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetTarget(c10910007.etarget)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetValue(c10910007.efilter)
	Duel.RegisterEffect(e4,tp)
end
function c10910007.etarget(e,c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x350) 
end
function c10910007.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end