--宝具 幻想大剑·天魔失坠
function c99999922.initial_effect(c)
	c:SetUniqueOnField(1,0,99999922)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99999922.target)
	e1:SetOperation(c99999922.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c99999922.eqlimit)
	c:RegisterEffect(e2)
	--Atk，def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64332231,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c99999922.destg2)
	e6:SetOperation(c99999922.desop2)
	c:RegisterEffect(e6)
end
function c99999922.eqlimit(e,c)
	return   c:IsCode(99999923) or c:IsSetCard(0x2e3) or  c:IsCode(99999987)
end
function c99999922.filter(c)
	return c:IsFaceup() and   (c:IsCode(99999923) or c:IsSetCard(0x2e3)  or  c:IsCode(99999987))
end
function c99999922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99999922.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99999922.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99999922.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99999922.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c99999922.dfilter(c)
	return c:IsDestructable() and c:IsFaceup() and  (c:IsDefensePos() or c:IsRace(RACE_DRAGON))
end
function c99999922.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler()
	local tc=g:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c99999922.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c99999922.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*400)
end
function c99999922.desop2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg1=Duel.GetMatchingGroup(c99999922.dfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(sg1,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end
end