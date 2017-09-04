--阿弥卡·克莲贝尔
function c10981030.initial_effect(c)
	c:SetUniqueOnField(1,1,10981030)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10981030.xyzcon)
	e0:SetOperation(c10981030.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10981030.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c10981030.defval)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c10981030.negcon)
	e3:SetTarget(c10981030.rettg)
	e3:SetOperation(c10981030.retop)
	c:RegisterEffect(e3)	
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c10981030.negcon2)
	e4:SetTarget(c10981030.rettg2)
	e4:SetOperation(c10981030.retop2)
	c:RegisterEffect(e4) 
end
function c10981030.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc)
end
function c10981030.xyzfilter1(c,g)
	return g:IsExists(c10981030.xyzfilter2,1,c,c:GetRank())
end
function c10981030.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c10981030.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c10981030.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c10981030.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and (not min or min<=2 and max>=2)
		and mg:IsExists(c10981030.xyzfilter1,1,nil,mg)
end
function c10981030.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	local sg=Group.CreateGroup()
	if og and not min then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=nil
		if og then
			mg=og:Filter(c10981030.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c10981030.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c10981030.xyzfilter1,1,1,nil,mg)
		local tc1=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c10981030.xyzfilter2,1,1,tc1,tc1:GetRank())
		local tc2=g2:GetFirst()
		g:Merge(g2)
		sg:Merge(tc1:GetOverlayGroup())
		sg:Merge(tc2:GetOverlayGroup())
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c10981030.atkfilter(c)
	return c:IsRace(RACE_MACHINE) and c:GetAttack()>=0
end
function c10981030.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10981030.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c10981030.deffilter(c)
	return c:IsRace(RACE_MACHINE) and c:GetDefense()>=0
end
function c10981030.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c10981030.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c10981030.filter1(c)
	return c:IsType(TYPE_TOKEN) or c:IsType(TYPE_SYNCHRO)
end
function c10981030.rtfilter(c)
	return c:IsType(TYPE_XYZ) 
end
function c10981030.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c10981030.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	and Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayGroup():IsExists(c10981030.rtfilter,1,nil)
end
function c10981030.retfilter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c10981030.retfilter2(c)
	return c:IsAbleToHand()
end
function c10981030.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetOverlayCount()
	if ct<=0 then return end
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10981030.retfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c10981030.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c10981030.retfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c10981030.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c10981030.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
	Duel.BreakEffect()
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c10981030.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10981030.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	and e:GetHandler():GetOverlayGroup():IsExists(c10981030.rtfilter,1,nil)
end
function c10981030.retfilter3(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeck()
end
function c10981030.rettg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetOverlayCount()
	if ct<=0 then return end
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10981030.retfilter3,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c10981030.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c10981030.retfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c10981030.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c10981030.retop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
	Duel.BreakEffect()
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end