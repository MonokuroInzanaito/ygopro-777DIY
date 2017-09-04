--混沌的未来诗
function c99998945.initial_effect(c) 
	c:SetUniqueOnField(1,0,99998945)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c99998945.actcon)
	c:RegisterEffect(e1)  
	 --rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c99998945.descon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99998945,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c99998945.tkcon)
	e3:SetCost(c99998945.descost)
	e3:SetTarget(c99998945.destg)
	e3:SetOperation(c99998945.desop)
	c:RegisterEffect(e3)
	--oraora
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE) 
	e4:SetTargetRange(LOCATION_MZONE,0)  
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetCondition(c99998945.tkcon2)
	e4:SetTarget(c99998945.tg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c99998945.tkcon3)
	e5:SetOperation(c99998945.aclimit1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_NEGATED)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c99998945.tkcon3)
	e6:SetOperation(c99998945.aclimit2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(1,0)
	e7:SetCondition(c99998945.econ1)
	e7:SetValue(c99998945.elimit)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetOperation(c99998945.aclimit3)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetOperation(c99998945.aclimit4)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCondition(c99998945.econ2)
	e10:SetTargetRange(0,1)
	c:RegisterEffect(e10)
end
function c99998945.actfilter(c)
	return c:IsFaceup() and c:IsCode(99998946) 
end
function c99998945.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998945.actfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99998945.descon(e)
	return not Duel.IsExistingMatchingCard(c99998945.actfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c99998945.tkfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_TOKEN)
end
function c99998945.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998945.tkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99998945.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_TOKEN)
	Duel.Release(g,REASON_COST)
end
function c99998945.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsDestructable() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99998945.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c99998945.tkfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_TOKEN)
end
function c99998945.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998945.tkfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c99998945.tg(e,c)
	return c:IsType(TYPE_TOKEN)
end
function c99998945.tkfilter3(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_TOKEN)
end
function c99998945.tkcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998945.tkfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c99998945.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER)  then return end
	e:GetHandler():RegisterFlagEffect(99998945,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c99998945.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(99998945)
end
function c99998945.econ1(e)
	return e:GetHandler():GetFlagEffect(99998945)~=0 and Duel.IsExistingMatchingCard(c99998945.tkfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c99998945.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER)  then return end
	e:GetHandler():RegisterFlagEffect(99998945,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c99998945.aclimit4(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(99998945)
end
function c99998945.econ2(e)
	return e:GetHandler():GetFlagEffect(99998945)~=0 and Duel.IsExistingMatchingCard(c99998945.tkfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c99998945.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) or not re:GetHandler():IsImmuneToEffect(e)
end