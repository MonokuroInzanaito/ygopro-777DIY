--夜之魇
function c10950011.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10950011.spcon)
	e0:SetOperation(c10950011.spop2)
	c:RegisterEffect(e0)
	--damage reduce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c10950011.damval)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--recover conversion
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_REVERSE_RECOVER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c10950011.desreptg)
	e6:SetOperation(c10950011.desrepop)
	c:RegisterEffect(e6)
	--summon success
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10950011,0))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(c10950011.addct)
	e7:SetOperation(c10950011.addc)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c10950011.efilter)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetValue(c10950011.efilter2)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetValue(c10950011.efilter3)
	c:RegisterEffect(e10)
end
function c10950011.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0x13ac,1)
		return 0
	end
	return val
end
function c10950011.spfilter(c)
	return c:IsCode(10950003) and c:IsAbleToGraveAsCost()
end
function c10950011.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x231) and c:IsType(TYPE_SYNCHRO)
end
function c10950011.syc(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,13,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x13ac,13,REASON_COST)
end
function c10950011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()   
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 
	and Duel.IsExistingMatchingCard(c10950011.spfilter2,tp,LOCATION_MZONE,0,2,nil) then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,13,REASON_COST) and Duel.IsExistingMatchingCard(c10950011.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) 
end
end
function c10950011.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10950011.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.RemoveCounter(tp,1,0,0x13ac,13,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST) 
end
function c10950011.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x13ac)>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(10950011,1))
end
function c10950011.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x13ac,1,REASON_EFFECT)
end
function c10950011.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x13ac)
end
function c10950011.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x13ac,8)
	end
end
function c10950011.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and not (te:GetHandler():IsAttribute(ATTRIBUTE_DARK) or te:GetHandler():IsAttribute(ATTRIBUTE_LIGHT))
end
function c10950011.efilter2(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c10950011.efilter3(e,te)
	return te:IsActiveType(TYPE_SPELL)
end