--传说之枪兵 罗慕路斯
function c99998975.initial_effect(c)
    c:SetUniqueOnField(1,0,99998975)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c99998975.xyzfilter),5,2)
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991098,13))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c99998975.cost)
	e1:SetTarget(c99998975.target)
	e1:SetOperation(c99998975.operation)
	c:RegisterEffect(e1)
	 --pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c99998975.scon)
	e3:SetTarget(c99998975.stg)
	e3:SetOperation(c99998975.sop)
	c:RegisterEffect(e3)	
end
function c99998975.xyzfilter(c)
	return  (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99998975.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99998975.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:GetCode()~=99998975
end
function c99998975.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(0x14) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c99998975.cfilter,tp,0x14,0x14,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99998975.cfilter,tp,0x14,0x14,1,1,e:GetHandler())
end
function c99998975.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
	    local code=tc:GetOriginalCode()
		if not tc:IsType(TYPE_TOKEN+TYPE_TRAPMONSTER) then
			c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 2)
		end
	end
end
function c99998975.scon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99998975.sfilter(c)
	return c:IsCode(99998974) 
end
function c99998975.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998975.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c99998975.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local  g=Duel.SelectMatchingCard(tp,c99998975.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc  then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand()  or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			
		end
end
end