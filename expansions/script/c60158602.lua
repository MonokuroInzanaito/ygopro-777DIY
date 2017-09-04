--原罪碎片 怠惰的零渊
function c60158602.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c60158602.condition)
	e1:SetTarget(c60158602.target)
	e1:SetOperation(c60158602.operation)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetValue(aux.tgoval)
	e2:SetCondition(c60158602.rmcon)
	c:RegisterEffect(e2)
	--cannot remove
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158601,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e3:SetCountLimit(1,6018602)
    e3:SetCost(c60158602.spcost)
    e3:SetTarget(c60158602.sptg)
    e3:SetOperation(c60158602.spop)
    c:RegisterEffect(e3)
end
function c60158602.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsRace(RACE_FIEND))
end
function c60158602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60158602.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
function c60158602.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalRace()==RACE_FIEND
end
function c60158602.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c60158602.spfilter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158602.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c60158602.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158602.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
