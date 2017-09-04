--天之锁
function c99998971.initial_effect(c)
	c:SetUniqueOnField(1,0,99998971)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(c99998971.actcon)
	e1:SetTarget(c99998971.target)
	e1:SetOperation(c99998971.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c99998971.descon)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetLabel(1)
	e4:SetCondition(c99998971.lvcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_CANNOT_RELEASE)
	e7:SetLabel(6)
	e7:SetValue(1)
	e7:SetCondition(c99998971.lvcon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e10)
	local e11=e7:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e11)
	--indes
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetValue(c99998971.indval)
	e12:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e12:SetLabel(4)
	e12:SetCondition(c99998971.lvcon)
	c:RegisterEffect(e12)
	--immune
	local e13=e12:Clone()
	e13:SetLabel(8)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c99998971.tgvalue)
	c:RegisterEffect(e13)
end
function c99998971.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2e3)
end
function c99998971.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998971.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99998971.filter(c)
	return c:IsFaceup() 
end
function c99998971.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99998971.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99998971.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99998971.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99998971.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c99998971.descon(e)
	return not Duel.IsExistingMatchingCard(c99998971.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end
function c99998971.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipTarget()
	if g:IsType(TYPE_XYZ) then
	return g:GetRank()>=e:GetLabel() 
	else
	return g:GetLevel()>=e:GetLabel() 
end
end
function c99998971.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c99998971.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end