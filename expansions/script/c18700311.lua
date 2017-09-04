--亡靈
function c18700311.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17393207,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18700311)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c18700311.cost)
	e1:SetTarget(c18700311.target)
	e1:SetOperation(c18700311.operation)
	c:RegisterEffect(e1)
	--ritual material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73176465,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,18700311)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c18700311.condtion)
	e1:SetTarget(c18700311.target)
	e1:SetOperation(c18700311.operation)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c18700311.condition1)
	e2:SetOperation(c18700311.operation1)
	c:RegisterEffect(e2)
end
function c18700311.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c18700311.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()  end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c18700311.filter(c)
	return c:IsSetCard(0xabb) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c18700311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18700311.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18700311.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18700311.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18700311.condition1(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and re:GetHandler():IsSetCard(0xabb)
end
function c18700311.operation1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc:GetFlagEffect(18700311)==0 then
		--untargetable
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(18700311,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(c18700311.tglimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1)
		rc:RegisterFlagEffect(18700311,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c18700311.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end