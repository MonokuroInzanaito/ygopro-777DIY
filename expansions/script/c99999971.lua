--传说之骑士 卫宫士郎
function c99999971.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,99999987),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99999971.scon)
	e1:SetTarget(c99999971.stg)
	e1:SetOperation(c99999971.sop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99991095,8))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c99999971.coptg)
	e2:SetOperation(c99999971.copop)
	c:RegisterEffect(e2)
	--add code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(99999987)
	c:RegisterEffect(e3)
end
function c99999971.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99999971.jsfilter(c)
	return c:GetCode()==99999982  and c:IsAbleToHand()
end
function c99999971.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999971.jsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99999971.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99999971.jsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
function c99999971.sfilter(c)
	return  c:IsType(TYPE_EQUIP) and  c:IsFaceup() and not c:IsCode(99998966)
end
function c99999971.coptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c99999971.sfilter,tp,0x38,0x38,1,nil) 
    and	Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c99999971.sfilter,tp,0x38,0x38,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c99999971.copop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and  e:GetHandler():IsRelateToEffect(e) and  e:GetHandler():IsFaceup() then
	local g=Group.FromCards(Duel.CreateToken(tp,99998966))
		local tg=g:GetFirst()
		Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		if Duel.Equip(tp,tg,e:GetHandler(),true) then
		tg:CopyEffect(tc:GetOriginalCode(),nil)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetOriginalCode())
		e1:SetReset(RESET_EVENT+0xfe0000)
		tg:RegisterEffect(e1)
	  end
	  end
end
