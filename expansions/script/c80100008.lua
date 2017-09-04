--幻想物语 南瓜马车与玻璃鞋
function c80100008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80100008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80100008.rlcost)
	e1:SetTarget(c80100008.target)
	e1:SetOperation(c80100008.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80100008,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80110008)
	e2:SetCost(c80100008.thcost)
	e2:SetTarget(c80100008.thtg)
	e2:SetOperation(c80100008.thop)
	c:RegisterEffect(e2)
end
function c80100008.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c80100008.filter(c,e,tp)
	return c:IsCode(80100003) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80100008.thfilter(c)
	return c:IsSetCard(0x3400) and not c:IsDisabled()
end
function c80100008.desfilter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c80100008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80100008.thfilter(chkc) end
	local b1=Duel.IsExistingMatchingCard(c80100008.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c80100008.thfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(80100008,0),aux.Stringid(80100008,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(80100008,0))
	else 
		op=Duel.SelectOption(tp,aux.Stringid(80100008,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c80100008.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function c80100008.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		--Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SelectOption(1-tp,aux.Stringid(80100008,0))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c80100008.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if g:GetCount()>0 then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		--Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SelectOption(1-tp,aux.Stringid(80100008,1))
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local ea=Effect.CreateEffect(e:GetHandler())
			ea:SetType(EFFECT_TYPE_SINGLE)
			ea:SetCode(EFFECT_DISABLE)
			ea:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(ea)
			local eb=Effect.CreateEffect(e:GetHandler())
			eb:SetType(EFFECT_TYPE_SINGLE)
			eb:SetCode(EFFECT_DISABLE_EFFECT)
			eb:SetValue(RESET_TURN_SET)
			eb:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(eb)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e3:SetValue(c80100008.efilter)
			--Duel.RegisterEffect(e3,tp)
			tc:RegisterEffect(e3)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetLabelObject(tc)
			e5:SetCode(EVENT_PHASE+PHASE_END)
			e5:SetOperation(c80100008.retop)
			e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e5:SetCountLimit(1)
			tc:RegisterEffect(e5,tp)
		end
	end
end
function c80100008.efilter(e,re,rp)
	return e:GetHandlerPlayer()~=rp
end
function c80100008.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,80100008)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c80100008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0x3400) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0x3400)
	Duel.Release(sg,REASON_COST)
end
function c80100008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c80100008.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end

