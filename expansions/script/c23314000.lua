--幻界龙神 雷魂
function c23314000.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23314000,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c23314000.cost)
	e1:SetTarget(c23314000.target)
	e1:SetOperation(c23314000.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23314000,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c23314000.thcon)
	e2:SetTarget(c23314000.thtg)
	e2:SetOperation(c23314000.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23314000,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c23314000.spcost)
	e3:SetTarget(c23314000.sptg)
	e3:SetOperation(c23314000.spop)
	c:RegisterEffect(e3)
end
function c23314000.costfilter(c)
	return c:IsSetCard(0x299e)
end
function c23314000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c23314000.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c23314000.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c23314000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c23314000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c23314000.thcon(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_MONSTER) or c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c23314000.tdfilter(c,e,tp)
	return c:IsSetCard(0x99e) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c23314000.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c23314000.thfilter(c,e,tp,code)
	return c:IsSetCard(0x299e) and not c:IsCode(code) and c:IsAbleToHand()
end
function c23314000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c23314000.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23314000.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c23314000.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabel(0)
	if e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c23314000.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 and not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23314000.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g:GetFirst())
		if tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
function c23314000.spfilter(c)
	return c:IsSetCard(0x299e) and c:IsAbleToDeckAsCost()
end
function c23314000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23314000.spfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c23314000.spfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c23314000.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c23314000.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	g:Merge(Duel.SelectMatchingCard(tp,c23314000.spfilter,tp,LOCATION_MZONE,0,1,1,nil))
	g:Merge(Duel.SelectMatchingCard(tp,c23314000.spfilter,tp,LOCATION_GRAVE,0,1,1,nil))
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c23314000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function c23314000.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	if not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,3,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end