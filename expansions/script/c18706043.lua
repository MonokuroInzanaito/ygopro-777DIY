--岛津风
function c18706043.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),2,2,c18706043.ovfilter,aux.Stringid(18706043,0),2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54359696,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,18706043)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c18706043.sptg)
	e1:SetOperation(c18706043.spop)
	c:RegisterEffect(e1)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(12014404,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18706043)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c18706043.cost)
	e1:SetTarget(c18706043.target)
	e1:SetOperation(c18706043.operation)
	c:RegisterEffect(e1)
end
function c18706043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18706043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c18706043.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,300,REASON_EFFECT)
	local ft=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if ft<=0 then return end
	for i=1,ft-1 do
	Duel.Hint(HINT_CARD,0,27053506)
	Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c18706043.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabb) and c:IsType(TYPE_XYZ) and not c:IsCode(18706043)
end
function c18706043.filter(c,e,tp)
	return c:IsSetCard(0xabb) and not c:IsCode(18706043) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18706043.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18706043.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18706043.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c18706043.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18706043.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if g:GetCount()>0 then
			Duel.Overlay(tc,e:GetHandler())
		end
	end
end