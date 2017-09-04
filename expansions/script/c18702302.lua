--神操鸟 永寂海之塞壬
function c18702302.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	c:EnableReviveLimit()
	--destroy & damage
	--local e5=Effect.CreateEffect(c)
	--e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	--e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	--e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	--e5:SetCode(EVENT_CHAINING)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetCountLimit(1,18702302)
	--e5:SetCondition(c18702302.con)
	--e5:SetCost(c18702302.setcost)
	--e5:SetTarget(c18702302.settg)
	--e5:SetOperation(c18702302.setop)
	--c:RegisterEffect(e5)
	--search
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(61901281,0))
	--e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	--e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	--e3:SetCode(EVENT_TO_GRAVE)
	--e3:SetCondition(c18702302.condition)
	--e3:SetTarget(c18702302.target)
	--e3:SetOperation(c18702302.operation)
	--c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19261966,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c18702302.condition)
	e4:SetTarget(c18702302.thtg)
	e4:SetOperation(c18702302.thop)
	c:RegisterEffect(e4)
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c18702302.code)
	e1:SetValue(0x6ab2)
	c:RegisterEffect(e1)
end
function c18702302.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_CHAINING) and re:IsActiveType(TYPE_MONSTER) and rp~=tp
end
function c18702302.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18702302.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsLevelAbove(5)
end
function c18702302.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c18702302.tdfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c18702302.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c18702302.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c18702302.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c18702302.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c18702302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702302.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18702302.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18702302.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c18702302.setfilter(c,e)
	return c:IsSetCard(0x6ab2) and c:IsAbleToGrave()
end
function c18702302.thfilter(c)
	return c:IsSetCard(0x6ab2) and c:IsAbleToHand()
end
function c18702302.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18702302.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18702302.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c18702302.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c18702302.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c18702302.code(e,c)
	return c:IsFaceup()
end