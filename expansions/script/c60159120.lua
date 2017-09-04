--原罪的尽头
function c60159120.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,60159120)
    e1:SetCost(c60159120.cost)
    e1:SetTarget(c60159120.target)
    e1:SetOperation(c60159120.activate)
    c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159101,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c60159120.condition)
    e2:SetCost(c60159120.cost2)
	e2:SetTarget(c60159120.settg)
	e2:SetOperation(c60159120.setop)
	c:RegisterEffect(e2)
end
function c60159120.cfilter(c,e,tp)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingTarget(c60159120.filter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c60159120.filter(c,e,tp)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if chk==0 then return Duel.IsExistingMatchingCard(c60159120.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c60159120.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,e,tp)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		if chk==0 then return Duel.IsExistingMatchingCard(c60159120.cfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c60159120.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c60159120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60159120.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60159120.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
        c:CancelToGrave()
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c60159120.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) 
		and eg:GetFirst():IsSetCard(0x3b25) and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c60159120.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60159120.cfilter2(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c60159120.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159120.cfilter2,tp,LOCATION_REMOVED,0,1,nil) end
end
function c60159120.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c60159120,tp,0,LOCATION_REMOVED,1,1,nil)
    if g:GetCount()>0 then
		local tc=g:GetFirst()
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        tc:RegisterEffect(e1)
    end
end
