--操鸟术
function c18702322.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c18702322.target)
	e1:SetOperation(c18702322.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c18702322.hdcon)
	e2:SetTarget(c18702322.target1)
	e2:SetOperation(c18702322.activate)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c18702322.target)
	e1:SetOperation(c18702322.activate)
	c:RegisterEffect(e1)
end
function c18702322.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x6ab2)
end
function c18702322.filter1(c,tp,ep)
	return c:IsSetCard(0x6ab2) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c18702322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if ep~=tp then return false end
	local tc=eg:GetFirst()
	if chk==0 then return c18702322.filter(tc,tp,ep) and Duel.IsExistingMatchingCard(c18702322.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18702322.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18702322.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18702322.ccfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6ab2) and c:IsType(TYPE_MONSTER)
end
function c18702322.hdcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	local c=e:GetHandler()
	return eg:IsExists(c18702322.ccfilter,1,nil,tp)
end
function c18702322.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702322.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
