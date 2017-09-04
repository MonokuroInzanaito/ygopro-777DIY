--灵摆换将 永续魔法
function c60158911.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158911,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,60158911)
    e2:SetTarget(c60158911.ptg)
    e2:SetOperation(c60158911.pop)
    c:RegisterEffect(e2)
	--to ex
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158911,1))
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCountLimit(1,60158911)
    e3:SetTarget(c60158911.ptg2)
    e3:SetOperation(c60158911.pop2)
    c:RegisterEffect(e3)
end
function c60158911.pfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c60158911.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158911.pfilter,tp,LOCATION_EXTRA,0,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToDec,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158911.pop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60158911.pfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g2,nil,1,REASON_EFFECT)
		end
    end
end
function c60158911.pfilter2(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c60158911.ptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158911.pfilter2,tp,LOCATION_HAND,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158911.pop2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158911,2))
    local g=Duel.SelectMatchingCard(tp,c60158911.pfilter2,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		Duel.Draw(p,d,REASON_EFFECT)
    end
end