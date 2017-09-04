--双兔傍地走
function c18700104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18700104)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c18700104.target)
	e1:SetOperation(c18700104.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c18700104.handcon)
	c:RegisterEffect(e2)
end
function c18700104.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c18700104.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp) and c:IsSetCard(0xab0) and c:IsFaceup()
end
function c18700104.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsSetCard(0xabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18700104.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c18700104.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local rg=Duel.SelectTarget(tp,c18700104.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c18700104.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18700104.spfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
end
function c18700104.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c18700104.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c18700104.hdfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c18700104.hdfilter(c)
	return c:IsSetCard(0xabb)
end
function c18700104.hdfilter2(c)
	return c:IsSetCard(0xab0)
end