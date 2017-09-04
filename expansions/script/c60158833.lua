--红色骑士团·幻想少年领域
function c60158833.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5b28))
    e2:SetValue(300)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1,60158833)
    e3:SetCondition(c60158833.atkcon)
    e3:SetTarget(c60158833.atktar)
    e3:SetOperation(c60158833.atkop)
    c:RegisterEffect(e3)
	--
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60158833,0))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,6018832)
    e4:SetCondition(c60158833.con)
    e4:SetTarget(c60158833.tg)
    e4:SetOperation(c60158833.op)
    c:RegisterEffect(e4)
end
function c60158833.afilter(c,re,tp)
    return c:IsSetCard(0x5b28) and c:IsReason(REASON_COST) and c:IsControler(tp) and re:IsHasType(0x7f0)
		and c:IsAbleToHand()
end
function c60158833.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(c60158833.afilter,nil,re,tp)
    return ct==1
end
function c60158833.atktar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c60158833.afilter,1,nil,re,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
	e:SetLabelObject(eg:Filter(c60158833.afilter,nil,re,tp):GetFirst())
end
function c60158833.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if g:GetCount()==1 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60158833.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
end
function c60158833.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c60158833.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
