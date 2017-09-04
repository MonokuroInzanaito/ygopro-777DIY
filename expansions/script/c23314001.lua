--幻界龙狮 莱昂纳尔
function c23314001.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23314001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c23314001.cost)
	e1:SetTarget(c23314001.target)
	e1:SetOperation(c23314001.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23314001,1))
	e2:SetCategory(CATEGORY_TOHAND+HINTMSG_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c23314001.thcon)
	e2:SetTarget(c23314001.thtg)
	e2:SetOperation(c23314001.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23314001,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c23314001.spcost)
	e3:SetTarget(c23314001.sptg)
	e3:SetOperation(c23314001.spop)
	c:RegisterEffect(e3)
end
function c23314001.costfilter(c)
	return c:IsSetCard(0x299e)
end
function c23314001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c23314001.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c23314001.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c23314001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c23314001.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c23314001.thcon(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_MONSTER) or c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c23314001.tdfilter(c,e,tp)
	return c:IsSetCard(0x299e) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c23314001.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c23314001.thfilter(c,e,tp,code)
	return c:IsSetCard(0x99e) and not c:IsCode(code) and c:IsAbleToGrave()
end
function c23314001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c23314001.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23314001.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c23314001.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabel(0)
	if e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c23314001.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 and not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23314001.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c23314001.spfilter(c)
	return c:IsSetCard(0x299e) and c:IsAbleToDeckAsCost()
end
function c23314001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23314001.spfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c23314001.spfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c23314001.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c23314001.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	g:Merge(Duel.SelectMatchingCard(tp,c23314001.spfilter,tp,LOCATION_MZONE,0,1,1,nil))
	g:Merge(Duel.SelectMatchingCard(tp,c23314001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil))
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c23314001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23314001.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
end