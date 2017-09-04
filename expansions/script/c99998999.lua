--疯狂之月
function c99998999.initial_effect(c)
	c:SetUniqueOnField(1,0,99998999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
    e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99998999.target)
	e1:SetOperation(c99998999.operation)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(79856792,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c99998999.tdcost)
	e2:SetTarget(c99998999.tdtg)
	e2:SetOperation(c99998999.tdop)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c99998999.eqlimit)
	c:RegisterEffect(e3)
end
function c99998999.eqlimit(e,c)
	return  c:IsCode(99998995) or c:IsCode(99999926) 
end
function c99998999.filter(c)
	return c:IsFaceup() and (c:IsCode(99998995) or c:IsCode(99999926)) 
end
function c99998999.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99998999.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99998999.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99998999.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99998999.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c99998999.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99998999.cfilter(c,def)
	return (c:IsFacedown() or c:GetDefense()<=def) and not (c:IsSetCard(0x2e1) or c:IsSetCard(0x2e0)) and c:IsAbleToDeck()
end
function c99998999.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler():GetEquipTarget()
	local  def=c:GetDefense()
	if chk==0 then return Duel.IsExistingMatchingCard(c99998999.cfilter,tp,0,LOCATION_MZONE,1,nil,def) end
	local g=Duel.GetMatchingGroup(c99998999.cfilter,tp,0,LOCATION_MZONE,nil,def)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99998999.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetEquipTarget()
	local  def=c:GetDefense()
    if  not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c99998999.cfilter,tp,0,LOCATION_MZONE,nil,def)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end