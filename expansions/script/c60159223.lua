--予自深洋的呼唤
function c60159223.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c60159223.cost)
    e1:SetTarget(c60159223.target)
    e1:SetOperation(c60159223.activate)
    c:RegisterEffect(e1)
	--todeck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159223,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(c60159223.thcost)
    e2:SetTarget(c60159223.thtg)
    e2:SetOperation(c60159223.thop)
    c:RegisterEffect(e2)
end
function c60159223.cfilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function c60159223.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159223.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c60159223.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c60159223.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(3)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
end
function c60159223.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)==3 then
        Duel.ShuffleHand(p)
        Duel.BreakEffect()
        local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
        if g:GetCount()>0 and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER) then
            Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
            local sg1=g:FilterSelect(p,Card.IsAttribute,1,1,nil,ATTRIBUTE_WATER)
            Duel.ConfirmCards(1-p,sg1)
            local opt=Duel.SelectOption(tp,aux.Stringid(60159223,1),aux.Stringid(60159223,2))
			if opt==0 then
				Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)
			else
				Duel.SendtoDeck(sg1,nil,1,REASON_EFFECT)
			end
        else
            local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
            Duel.ConfirmCards(1-p,hg)
            Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
        end
    end
			--can't not 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetTargetRange(LOCATION_DECK,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_DRAW)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTargetRange(1,0)
			Duel.RegisterEffect(e2,tp)
end
function c60159223.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60159223.thfilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck()
end
function c60159223.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c60159223.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60159223.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.SelectTarget(tp,c60159223.thfilter,tp,LOCATION_GRAVE,0,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c60159223.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
