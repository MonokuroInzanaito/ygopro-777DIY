--红魔馆
function c99998940.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998940,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c99998940.cost)
	e2:SetTarget(c99998940.sptg)
	e2:SetOperation(c99998940.spop)
	c:RegisterEffect(e2)
end
function c99998940.ovfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(99998941) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c99998940.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998940.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c99998940.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	g:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99998940.filter(c,e,tp)
	return (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7))  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99998940.atkfilter(c)
	return c:IsFaceup() and c:IsCode(99998941) 
end
function c99998940.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99998940.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99998940.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99998940.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99998940.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and 
	tc:GetAttack()>0 and  Duel.IsExistingMatchingCard(c99998940.atkfilter,tp,LOCATION_MZONE,0,1,nil) then
	local g=Duel.GetMatchingGroup(c99998940.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetFirst()
	while tg do
	if tg:IsFaceup() then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	tg:RegisterEffect(e1)
	end
	tg=g:GetNext()
end
end
end