--崩坏神格 刻音
function c75646514.initial_effect(c)
	c:EnableCounterPermit(0x1b,LOCATION_SZONE)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(c75646514.eqtg)
	e1:SetOperation(c75646514.eqop)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(900)
	e2:SetCondition(c75646514.con)
	c:RegisterEffect(e2)
	--eq2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c75646514.eqcon)
	e3:SetTarget(c75646514.eqtg2)
	e3:SetOperation(c75646514.eqop2)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(3,75646503)
	e5:SetCost(c75646514.thcost)
	e5:SetTarget(c75646514.thtg)
	e5:SetOperation(c75646514.thop)
	c:RegisterEffect(e5)
end
function c75646514.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c5) and c:GetBaseAttack()==7  and c:GetEquipGroup():FilterCount(c75646514.filter2,nil)<3
end
function c75646514.filter2(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP)
end
function c75646514.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75646514.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c75646514.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c75646514.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75646514.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c75646514.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	e:GetHandler():AddCounter(0x1b,2)
end
function c75646514.eqlimit(e,c)
	return c==e:GetLabelObject() and c:GetEquipGroup():FilterCount(c75646514.filter2,nil)<4
end
function c75646514.con(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646514.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:GetEquipGroup():FilterCount(c75646514.filter2,nil)<3
		and e:GetHandler():GetCounter(0x1b)>0
end
function c75646514.filter3(c,e,tp,ec)
	return c:IsCode(75646514)
end
function c75646514.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c75646514.filter3,tp,LOCATION_DECK,0,1,nil,e,tp,tc) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local g=Duel.GetMatchingGroup(c75646514.filter3,tp,LOCATION_DECK,0,nil,e,tp,tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c75646514.eqop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646510,0))
	local g=Duel.SelectMatchingCard(tp,c75646514.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsFacedown() then return end
	local etc=g:GetFirst()
	e:GetHandler():RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	Duel.Equip(tp,etc,c,true)
	local e1=Effect.CreateEffect(etc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c75646514.eqlimit1)
	e1:SetLabelObject(c)
	etc:RegisterEffect(e1)
	etc:AddCounter(0x1b,1)
end
function c75646514.eqlimit1(e,c)
	return c==e:GetLabelObject()
end
function c75646514.cfilter(c)
	return (c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP)) or c:IsSetCard(0x32c5) and c:IsAbleToRemoveAsCost()
end
function c75646514.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75646514.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646514.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646514.thfilter(c)
	return c:IsSetCard(0x2c5) and c:IsAbleToHand()
end
function c75646514.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646514.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646514.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646514.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end