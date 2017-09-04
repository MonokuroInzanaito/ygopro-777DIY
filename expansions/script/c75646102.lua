--Pleiades 树
function c75646102.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646102,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75646102)
	e1:SetCost(c75646102.drcost)
	e1:SetTarget(c75646102.drtg)
	e1:SetOperation(c75646102.drop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c75646102.con)
	e2:SetTarget(c75646102.target)
	e2:SetOperation(c75646102.op)
	c:RegisterEffect(e2)
end
function c75646102.cfilter(c)
	return c:IsSetCard(0x2c0) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c75646102.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646102.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646102.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646102.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75646102.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c75646102.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7f0)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c75646102.filter(c)
	return c:IsAbleToDeck()
end
function c75646102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75646102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646102.filter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75646102.filter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c75646102.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2c0) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c75646102.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==2 then
		local tg=Duel.GetMatchingGroup(c75646102.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(75646102,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end