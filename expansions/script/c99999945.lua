--王之理想乡 阿瓦隆
function c99999945.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c99999945.actcon)
	c:RegisterEffect(e1)
    --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c99999945.descon)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76136345,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c99999945.thtg)
	e3:SetOperation(c99999945.thop)
	c:RegisterEffect(e3)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(0)
	c:RegisterEffect(e4)
    --no damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(0)
	c:RegisterEffect(e5)
   --immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c99999945.imfilter)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c99999945.tg)
	e7:SetValue(c99999945.efilter)
	c:RegisterEffect(e7)
end
function c99999945.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2e2)
end
function c99999945.actfilter2(c)
	return c:IsFaceup() and c:IsCode(99999981) 
end
function c99999945.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99999945.actfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c99999945.actfilter2,tp,LOCATION_SZONE,0,1,nil)
end
function c99999945.descon(e)
	return not Duel.IsExistingMatchingCard(c99999945.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	or not  Duel.IsExistingMatchingCard(c99999945.actfilter2,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c99999945.thfilter(c)
	return(c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99999945.thfilter2(c)
	return c:IsSetCard(0x2e2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99999945.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999945.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c99999945.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99999945.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c99999945.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c99999945.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
end
function c99999945.imfilter(e,te)
	local c=te:GetHandler()
	return  c:IsCode(99999963)
end
function c99999945.tg(e,c)
   return c:IsFaceup() and c:IsSetCard(0x2e2)
end
function c99999945.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c99999945.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end