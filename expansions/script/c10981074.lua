--远古挖掘
function c10981074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10981074.condition)
	e1:SetCost(c10981074.cost)
	e1:SetTarget(c10981074.target)
	e1:SetOperation(c10981074.activate)
	c:RegisterEffect(e1)	
end
function c10981074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,5) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	Duel.DiscardDeck(tp,5,REASON_COST)
end
function c10981074.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10981074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function c10981074.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if cg:GetClassCount(Card.GetCode)==cg:GetCount() then
	Duel.Draw(tp,1,REASON_EFFECT)
	else
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
end