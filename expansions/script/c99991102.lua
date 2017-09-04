--黑之饥荒
function c99991102.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42589641,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99991102.tdcon)
	e1:SetTarget(c99991102.tdtg)
	e1:SetOperation(c99991102.tdop)
	c:RegisterEffect(e1) 
	--hands
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c99991102.handes)
	c:RegisterEffect(e2)
end
function c99991102.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99991102.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99991102.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
end
c99991102[0]=0
function c99991102.handes(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if id==c99991102[0] or re:GetHandler()==e:GetHandler() then return end
	c99991102[0]=id
	if Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0 and Duel.SelectYesNo(ep,aux.Stringid(99991102,0)) then
	  local g=Duel.SelectMatchingCard(ep,Card.IsAbleToDeck,ep,LOCATION_HAND,0,1,1,nil)  
	  Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
	else
   if  Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
	re:GetHandler():CancelToGrave()
	Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
 end
end
end