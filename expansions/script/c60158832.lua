--红色骑士团·剑狱
function c60158832.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c60158832.aclimit)
    e2:SetCondition(c60158832.actcon)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158832,0))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,60158832)
    e3:SetCondition(c60158832.con)
    e3:SetTarget(c60158832.tg)
    e3:SetOperation(c60158832.op)
    c:RegisterEffect(e3)
end
function c60158832.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c60158832.cfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x5b28) and c:IsControler(tp)
end
function c60158832.actcon(e)
    local tp=e:GetHandlerPlayer()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a and c60158832.cfilter(a,tp)) or (d and c60158832.cfilter(d,tp))
end
function c60158832.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
end
function c60158832.filter2(c)
    return c:IsSetCard(0x5b28) and c:IsAbleToDeck()
end
function c60158832.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c60158832.filter2,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c60158832.filter2,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60158832.op(e,tp,eg,ep,ev,re,r,rp)
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
