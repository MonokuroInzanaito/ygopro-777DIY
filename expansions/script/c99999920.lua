--少女之贞洁
function c99999920.initial_effect(c)
	c:EnableCounterPermit(0x2e1)
	c:SetUniqueOnField(1,0,99999920)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99999920.target)
	e1:SetOperation(c99999920.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c99999920.eqlimit)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c99999920.reptg)
	e3:SetOperation(c99999920.repop)
	c:RegisterEffect(e3)
	--Add counter1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c99999920.cop1)
	c:RegisterEffect(e4)
	--Add counter2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(c99999920.ccon)
	e5:SetOperation(c99999920.cop2)
	c:RegisterEffect(e5)
	--[[--negate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c99999920.discon)
	e6:SetCost(c99999920.discost)
	e6:SetTarget(c99999920.distg)
	e6:SetOperation(c99999920.disop)
	c:RegisterEffect(e6)--]]
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_SZONE)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCondition(c99999920.descon)
	e7:SetCost(c99999920.descost)
	e7:SetTarget(c99999920.destg)
	e7:SetOperation(c99999920.desop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCondition(c99999920.descon2)
	c:RegisterEffect(e8)
	--atk\def
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetRange(LOCATION_SZONE)
	e9:SetValue(c99999920.atkval)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e10)
end
function c99999920.eqlimit(e,c)
	return c:IsCode(99999921) 
end
function c99999920.filter(c)
	return c:IsFaceup() and  c:IsCode(99999921) 
end
function c99999920.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99999920.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99999920.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99999920.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99999920.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c99999920.desreptg)
	e1:SetOperation(c99999920.desrepop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	end
end
function c99999920.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,1,0,0x2e1)>0 and not  e:GetHandler():IsReason(REASON_RULE)  end
    return 	 Duel.SelectYesNo(tp,aux.Stringid(99991097,11)) 
end
function c99999920.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(ep,1,0,0x2e1,1,REASON_EFFECT)
end
function c99999920.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,1,0,0x2e1)>0  and not e:GetHandler():IsReason(REASON_RULE) end
	return Duel.SelectYesNo(tp,aux.Stringid(99991097,10)) 
end
function c99999920.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x2e1,1,REASON_EFFECT)
end
function c99999920.cop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)  then
		e:GetHandler():AddCounter(0x2e1,1)
	end
end
function c99999920.ccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c99999920.cop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x2e1,2)
end
function c99999920.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(tc)   and Duel.IsChainNegatable(ev)
end
function c99999920.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x2e1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x2e1,2,REASON_COST)
end
function c99999920.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99999920.disop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c99999920.desfilter(c)
	return c:GetCounter(0x2e1)>0
end
function c99999920.descost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetCounter(tp,1,0,0x2e1)>0 end
    local ec=e:GetHandler():GetEquipTarget()
	local g=Duel.GetMatchingGroup(c99999920.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		local sct=tc:GetCounter(0x2e1)
		tc:RemoveCounter(tp,0x2e1,sct,0)
		sum=sum+sct
		tc=g:GetNext()
	end
	Duel.SendtoGrave(ec,nil,REASON_COST)
	e:SetLabel(sum)
end
function c99999920.descon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    return  ct1>=ct2
end
function c99999920.spfilter(c,e,tp)
	return  c:IsCode(99999921)  and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c99999920.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local g=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local d=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,d:GetCount(),0,0)
end
function c99999920.desop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if dg:GetCount()>0 then
    local	ct=Duel.Destroy(dg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0   or ct<5 then return end
		local g=Duel.GetMatchingGroup(c99999920.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if g:GetCount()>0  then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c99999920.descon2(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    return  ct1<ct2
end
function c99999920.atkval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x2e1)*400
end
