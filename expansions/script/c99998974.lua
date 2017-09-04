--宝具 万物经由吾枪生
function c99998974.initial_effect(c)
	c:SetUniqueOnField(1,0,99998974)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99998974.target)
	e1:SetOperation(c99998974.operation)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c99998974.condition)
	e2:SetTarget(c99998974.target2)
	e2:SetOperation(c99998974.operation2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c99998974.eqlimit)
	c:RegisterEffect(e3)
	--Atk,def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c99998974.val)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(c99998974.val)
	c:RegisterEffect(e5)
	--变素材	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_BATTLE_START)
    e6:SetCondition(c99998974.descon)
	e6:SetTarget(c99998974.destg)
	e6:SetOperation(c99998974.desop)
	c:RegisterEffect(e6)
end
function c99998974.eqlimit(e,c)
	return   c:IsCode(99999987)  or  c:IsCode(99998975) or c:IsSetCard(0x2e3)
end
function c99998974.filter(c)
	return c:IsFaceup() and  (c:IsCode(99999987)  or  c:IsCode(99998975) or c:IsSetCard(0x2e3))
end
function c99998974.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99998974.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99998974.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99998974.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99998974.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c99998974.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c99998974.cofilter(c)
	return  not  c:IsCode(99998973) 
end
function c99998974.target2(e,tp,eg,ep,ev,re,r,rp,chk)
     local c=e:GetHandler():GetEquipTarget()
	if chk==0 then return  Duel.IsExistingMatchingCard(c99998974.cofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
end
function c99998974.operation2(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler():GetEquipTarget()
	if  not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c99998974.cofilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0  then
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(99998973)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
end
function c99998974.cofilter2(c)
	return  c:IsFaceup() and c:IsCode(99998973) 
end
function c99998974.val(e,c)
	return Duel.GetMatchingGroupCount(c99998974.cofilter2,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function c99998974.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetEquipTarget():GetBattleTarget()
	local tc=c:GetEquipTarget()
	return bc and bc:GetCode()==99998973 and bc:IsControlerCanBeChanged() and tc:IsType(TYPE_XYZ) and not bc:IsType(TYPE_TOKEN)
end
function c99998974.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c99998974.desop(e,tp,eg,ep,ev,re,r,rp)
	if  not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler():GetEquipTarget()
	local tc=c:GetBattleTarget()
	if  tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end