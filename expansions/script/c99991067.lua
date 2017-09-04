--传说之狂战士 南丁格尔
function c99991067.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	 --damage conversion
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_REVERSE_DAMAGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c99991067.rev)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
    e2:SetCode(EFFECT_REVERSE_RECOVER)
    e2:SetTargetRange(0,1)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(99991067,0))
    e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,99991067)
    e3:SetTarget(c99991067.tg)
    e3:SetOperation(c99991067.op)
    c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99991067,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c99991067.thcost)
	e4:SetTarget(c99991067.thtg)
	e4:SetOperation(c99991067.thop)
	c:RegisterEffect(e4)
	--must attack
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e5)
end
function c99991067.rev(e,re,r,rp,rc)
    return bit.band(r,REASON_EFFECT)>0
end
function c99991067.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove()  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99991067.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(tp) and Duel.Remove(tc,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 then
         if tc:IsForbidden() then 
        Duel.SendtoGrave(tc,REASON_RULE)
    else Duel.ReturnToField(tc) 
 end
end
end
function c99991067.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99991067.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c99991067.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c99991067.thfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c99991067.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c99991067.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99991067.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
	Duel.Recover(tp,2000,REASON_EFFECT)
	end
end
