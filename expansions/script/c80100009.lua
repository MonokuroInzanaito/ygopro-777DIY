--幻想物语 化作泡沫的悲恋
function c80100009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80100009+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80100009.rlcost)
	e1:SetTarget(c80100009.target)
	e1:SetOperation(c80100009.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80100009,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80110009)
	e2:SetCost(c80100009.thcost)
	e2:SetTarget(c80100009.thtg)
	e2:SetOperation(c80100009.thop)
	c:RegisterEffect(e2)
end
function c80100009.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c80100009.filter(c,e,tp)
	return c:IsCode(80100004) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80100009.thfilter(c)
	return c:IsSetCard(0x3400) and c:IsDestructable()
end
function c80100009.desfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c80100009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80100009.thfilter(chkc) end
	local b1=Duel.IsExistingMatchingCard(c80100009.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c80100009.thfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(tp,1) 
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(80100009,0),aux.Stringid(80100009,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(80100009,0))
	else 
		op=Duel.SelectOption(tp,aux.Stringid(80100009,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c80100009.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c80100009.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		--Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SelectOption(1-tp,aux.Stringid(80100009,0))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c80100009.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if g:GetCount()>0 then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		--Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SelectOption(1-tp,aux.Stringid(80100009,1))
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
			--local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,2,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg=g:Select(tp,1,2,nil)
				local ct=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
				if ct==1 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
function c80100009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0x3400) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0x3400)
	Duel.Release(sg,REASON_COST)
end
function c80100009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c80100009.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end

