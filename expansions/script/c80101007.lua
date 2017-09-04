--名刀-鲶尾
function c80101007.initial_effect(c)
    c:SetUniqueOnField(1,0,80101007)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c80101007.target)
    e1:SetOperation(c80101007.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c80101007.eqlimit)
    c:RegisterEffect(e4)
    --ret&draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80101007,0))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,80101007)
    e3:SetTarget(c80101007.drtg)
    e3:SetOperation(c80101007.drop)
    c:RegisterEffect(e3)
    --Double Attack
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_EQUIP)
    e8:SetCode(EFFECT_EXTRA_ATTACK)
    e8:SetCondition(c80101007.flcon)
    e8:SetValue(1)
    c:RegisterEffect(e8)
    --salvage
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(80101007,1))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,81101106)
    e10:SetCost(c80101007.cost)
    e10:SetTarget(c80101007.tg)
    e10:SetOperation(c80101007.op)
    c:RegisterEffect(e10)
    --atkdown
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(c80101007.flcon)
    e2:SetValue(300)
    c:RegisterEffect(e2)
end
function c80101007.flcon(e)
	return (e:GetHandler():GetEquipTarget():IsSetCard(0x5400) and e:GetHandler():GetEquipTarget():IsType(TYPE_SYNCHRO)) 
		or e:GetHandler():GetEquipTarget():IsCode(80101002)
end
function c80101007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c80101007.thfilter(c)
    return c:IsCode(80101002) and c:IsAbleToHand()
end
function c80101007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101007.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80101007.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101007.eqlimit(e,c)
    return c:IsSetCard(0x5400)
end
function c80101007.eqfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80101007.eqfilter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80101007.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80101007.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80101007.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
        Duel.Equip(tp,c,tc)
    end
end
function c80101007.drfilter(c)
    return (c:IsSetCard(0x5400) or c:IsSetCard(0x6400)) and c:IsAbleToDeck()
end
function c80101007.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80101007.drfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c80101007.drfilter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c80101007.drfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80101007.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end

