--折光·棱镜
function c75646530.initial_effect(c)
	c:SetUniqueOnField(1,0,75646530)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75646530.target)
	e1:SetOperation(c75646530.activate)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c75646530.eqlimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c75646530.val)
	e3:SetCondition(c75646530.con)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c75646530.regop)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c75646530.damcon)
	e6:SetOperation(c75646530.damop)
	c:RegisterEffect(e6)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(3,75646503)
	e5:SetCost(c75646530.thcost)
	e5:SetTarget(c75646530.thtg)
	e5:SetOperation(c75646530.thop)
	c:RegisterEffect(e5)
end
function c75646530.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c5) and c:GetBaseAttack()==7 and c:GetEquipGroup():FilterCount(c75646530.filter2,nil)<3
end
function c75646530.filter2(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP)
end
function c75646530.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c75646530.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646530.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c75646530.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75646530.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		e:GetHandler():AddCounter(0x1b,5)
	end
end
function c75646530.eqlimit(e,c)
	return c:IsSetCard(0x2c5) and c:GetBaseAttack()==7 and c:GetEquipGroup():FilterCount(c75646530.filter2,nil)<4
end
function c75646530.con(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646530.val(e,c)
	local ct=c:GetCounter(0x12c5)
	return 500+ct*200
end
function c75646530.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75646530,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c75646530.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec:GetCounter(0x12c5)>0 and c:GetCounter(0x1b)>0 and ep~=tp and c:GetFlagEffect(75646530)~=0
end
function c75646530.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75646530)
	local ec=e:GetHandler():GetEquipTarget()
	local ct=ec:GetCounter(0x12c5)
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	e:GetHandler():RemoveCounter(tp,0x1b,1,REASON_EFFECT)
end
function c75646530.cfilter(c)
	return (c:IsSetCard(0x2c5) and c:IsType(TYPE_EQUIP)) or c:IsSetCard(0x32c5) and c:IsAbleToRemoveAsCost()
end
function c75646530.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75646530.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646530.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646530.thfilter(c)
	return c:IsSetCard(0x2c5) and c:IsAbleToHand()
end
function c75646530.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646530.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646530.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646530.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end