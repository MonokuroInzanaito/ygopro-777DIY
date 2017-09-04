--虚拟歌姬 星尘
function c1300040.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
--  e1:SetDescription(aux.Stringid(1300040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1300040)
	e1:SetCondition(c1300040.spcon)
	e1:SetCost(c1300040.spcost)
	e1:SetTarget(c1300040.sptg)
	e1:SetOperation(c1300040.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
--  e2:SetDescription(aux.Stringid(1300040,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c1300040.rmtg)
	e2:SetOperation(c1300040.rmop)
	c:RegisterEffect(e2)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end)
	c:RegisterEffect(e2)]]
	--event chaining
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1300040.discon)
	e2:SetTarget(c1300040.distg)
	e2:SetOperation(c1300040.disop)
	c:RegisterEffect(e2)
	--to deck and draw
	local e5=Effect.CreateEffect(c)
--  e5:SetDescription(aux.Stringid(1300040,2))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c1300040.tdcon)
	e5:SetTarget(c1300040.tdtg)
	e5:SetOperation(c1300040.tdop)
	c:RegisterEffect(e5)
end
function c1300040.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c1300040.spfilter(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr) and c:IsAbleToExtraAsCost() and c:IsSetCard(0x130)
end
function c1300040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g1=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH)
		local g2=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_WATER)
		local g3=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_FIRE)
		local g4=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)
		local mg=g1:Clone()
		mg:Merge(g2)
		mg:Merge(g3)
		mg:Merge(g4)
		return g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 and mg:GetCount()>=4 end
	local g1=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH)
	local g2=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_WATER)
	local g3=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_FIRE)
	local g4=Duel.GetMatchingGroup(c1300040.spfilter,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)
	local mg=g1:Clone()
	mg:Merge(g2)
	mg:Merge(g3)
	mg:Merge(g4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g1=mg:Select(tp,1,1,nil)
	mg:Sub(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g2=mg:Select(tp,1,1,nil)
	mg:Sub(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g3=mg:Select(tp,1,1,nil)
	mg:Sub(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g4=mg:Select(tp,1,1,nil)
	mg:Sub(g4)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.SendtoDeck(g1,nil,0,REASON_COST)
end
function c1300040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1300040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c1300040.sefilter(c)
	return c:IsSetCard(0x130) and c:IsAbleToHand()
end
function c1300040.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1300040.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1300040.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1300040.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1300040.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c1300040.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c1300040.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x0c,0x0c,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(31222701,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0x0c,0x0c,1,1,nil)
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
	end
end
function c1300040.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c1300040.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0x3e,0x3e,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,Duel.GetFieldGroupCount(tp,0x3e,0x3e),tp,0x3e)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1300040.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x3e,0x3e,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
