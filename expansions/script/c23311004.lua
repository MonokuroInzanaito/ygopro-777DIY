--北狄之半兽
function c23311004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23311004,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,23311004)
	e2:SetTarget(c23311004.sctg)
	e2:SetOperation(c23311004.scop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23311004,4))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,123311004)
	e3:SetCondition(c23311004.condition)
	e3:SetTarget(c23311004.target)
	e3:SetOperation(c23311004.operation)
	c:RegisterEffect(e3)
end
function c23311004.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c23311004.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c23311004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23311004.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c23311004.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c23311004.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)>0 and c:GetLeftScale()>2 and Duel.SelectYesNo(tp,aux.Stringid(23311004,3)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
	end
end
function c23311004.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_DECK) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c23311004.thfilter(c)
	return c:IsCode(23311001) and c:IsAbleToHand()
end
function c23311004.spfilter(c,e,tp,ft)
	return c:IsCode(23311003) and ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23311004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c23311004.thfilter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c23311004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	local op=1
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23311004,4))
	if Duel.IsExistingMatchingCard(c23311004.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c23311004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) then
		op=Duel.SelectOption(tp,aux.Stringid(23311004,1),aux.Stringid(23311004,2))
	elseif Duel.IsExistingMatchingCard(c23311004.thfilter,tp,LOCATION_DECK,0,1,nil) then 
		op=Duel.SelectOption(tp,aux.Stringid(23311004,1))
	else Duel.SelectOption(tp,aux.Stringid(23311004,2)) end
	e:SetLabel(op)
	if op==0 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) end
end
function c23311004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstMatchingCard(c23311004.thfilter,tp,LOCATION_DECK,0,nil)
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		if ft<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.GetFirstMatchingCard(c23311004.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,ft)
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end