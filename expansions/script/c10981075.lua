--幻龙姬 怒蛇
function c10981075.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10981075.spcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10981075,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10981075)
	e3:SetCost(c10981075.descost)
	e3:SetTarget(c10981075.target)
	e3:SetOperation(c10981075.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10981075,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10981075)
	e4:SetTarget(c10981075.target2)
	e4:SetOperation(c10981075.activate)
	c:RegisterEffect(e4)
end
function c10981075.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	return g:GetCount()>=7 and g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c10981075.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,5) end
	Duel.DiscardDeck(tp,5,REASON_COST)
end
function c10981075.filter0(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c10981075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return cg:GetClassCount(Card.GetCode)==cg:GetCount() and g:FilterCount(c10981075.filter0,nil)>=1 end
end
function c10981075.operation(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local g=Duel.GetMatchingGroup(c10981075.filter0,1-tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 and cg:GetClassCount(Card.GetCode)==cg:GetCount() then
	local rg=g:RandomSelect(tp,1)
	Duel.SendtoGrave(rg,REASON_EFFECT)
end
end
function c10981075.filter(c)
    return c:IsAbleToDeck()
end
function c10981075.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10981075.filter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c10981075.filter,tp,LOCATION_GRAVE,0,5,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c10981075.filter,tp,LOCATION_GRAVE,0,5,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10981075.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==5 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
