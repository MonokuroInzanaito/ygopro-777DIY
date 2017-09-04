--月之少女 艾丝特
function c18700329.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,18700329)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18700329.spcon)
	e1:SetOperation(c18700329.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95027497,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,187003290)
	e2:SetTarget(c18700329.tg)
	e2:SetOperation(c18700329.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c18700329.filter(c)
	return c:IsSetCard(0xab0) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c18700329.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18700329.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c18700329.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18700329.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if  c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(18700329,1)) then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c18700329.cfilter(c)
	return c:IsSetCard(0x3ab0) and c:IsAbleToRemoveAsCost()
end
function c18700329.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c18700329.cfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil,nil)

end
function c18700329.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738100.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end