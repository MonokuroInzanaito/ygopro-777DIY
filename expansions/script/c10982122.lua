--向日葵的坡道
function c10982122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c10982122.etarget)
	e2:SetValue(c10982122.efilter)
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10982122.condition)
	e3:SetTarget(c10982122.target)
	e3:SetOperation(c10982122.operation)
	c:RegisterEffect(e3)   
end
function c10982122.etarget(e,c)
	return c:IsType(TYPE_SPIRIT) or (c:IsSetCard(0x4236) and not c:IsType(TYPE_FUSION))
end
function c10982122.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function c10982122.cfilter(c)
	return c:IsFaceup() and c:IsCode(10982106) and c:GetDefense()==1350
end
function c10982122.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10982122.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10982122.thfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and c:IsFaceup()
end
function c10982122.thfilter2(c)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and c:IsFaceup()
end
function c10982122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10982122.thfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(c10982122.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c10982122.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10982122.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10982122.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 and g2:GetCount()>0 then
	g:Merge(g2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end