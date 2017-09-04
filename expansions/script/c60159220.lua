--别离的雨落
function c60159220.initial_effect(c)
	--Activate
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e11)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c60159220.ctcon)
	e2:SetOperation(c60159220.ctop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5b25))
	e3:SetCondition(c60159220.effcon1)
	e3:SetValue(c60159220.atkval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c60159220.effcon2)
	e4:SetTarget(c60159220.indtg)
	e4:SetValue(c60159220.indval)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c60159220.effcon3)
	e5:SetTarget(c60159220.reptg)
	e5:SetValue(c60159220.value)
	e5:SetOperation(c60159220.desop)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c60159220.effcon4)
	e6:SetTarget(c60159220.target)
	e6:SetOperation(c60159220.activate)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTarget(c60159220.reptg2)
	c:RegisterEffect(e7)
end
function c60159220.cfilter(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function c60159220.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60159220.cfilter,1,nil)
end
function c60159220.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c60159220.cfilter,nil)
	e:GetHandler():AddCounter(0x1137,ct)
end
function c60159220.effcon1(e)
	return e:GetHandler():GetCounter(0x1137)>=1
end
function c60159220.effcon2(e)
	return e:GetHandler():GetCounter(0x1137)>=2
end
function c60159220.effcon3(e)
	return e:GetHandler():GetCounter(0x1137)>=3
end
function c60159220.effcon4(e)
	return e:GetHandler():GetCounter(0x1137)>=4
end
function c60159220.atkval(e,c)
	return Duel.GetCounter(tp,1,1,0x1137)*50
end
function c60159220.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER)
		and c:IsReason(REASON_EFFECT) 
end
function c60159220.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c60159220.filter,1,nil,tp) end
	return true
end
function c60159220.indval(e,c)
	return c60159220.filter(c,e:GetHandlerPlayer())
end
function c60159220.repfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToGrave()
end
function c60159220.value(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c60159220.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c60159220.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c60159220.repfilter2,tp,LOCATION_MZONE,0,1,nil) 
	end
	return Duel.SelectYesNo(tp,aux.Stringid(60159220,0))
end
function c60159220.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5b25) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToGrave()
end
function c60159220.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(c60159220.dfilter,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60159220.repfilter,tp,LOCATION_MZONE,0,1,1,tc)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c60159220.filter2(c)
	return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60159220.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE+LOCATION_REMOVED and c60159220.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60159220.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60159220.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60159220.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c60159220.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and Duel.IsCanRemoveCounter(tp,1,0,0x1137,2,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(60159220,2)) then
		Duel.RemoveCounter(tp,1,0,0x1137,2,REASON_EFFECT)
		return true
	else return false end
end
