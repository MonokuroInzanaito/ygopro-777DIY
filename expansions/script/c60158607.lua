--原罪的深渊 傲慢
function c60158607.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),7,3)
    c:EnableReviveLimit()
	--spsummon limit
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.xyzlimit)
    c:RegisterEffect(e1)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158607,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,60158607)
    e2:SetHintTiming(0,0x1e0)
    e2:SetCost(c60158607.spcost)
    e2:SetTarget(c60158607.sptg)
    e2:SetOperation(c60158607.spop)
    c:RegisterEffect(e2)
	--Attribute
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_ADD_ATTRIBUTE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c60158607.att)
    c:RegisterEffect(e3)
	--immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c60158607.efilter)
    c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetValue(c60158607.efilter2)
    c:RegisterEffect(e5)
	--spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(60158607,1))
    e6:SetCategory(CATEGORY_TOGRAVE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetCondition(c60158607.scon)
    e6:SetTarget(c60158607.stg)
    e6:SetOperation(c60158607.sop)
    c:RegisterEffect(e6)
end
function c60158607.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60158607.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_FIEND)
end
function c60158607.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c60158607.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60158607.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60158607.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60158607.att(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0xab28)
	local att=0
    local tc=g:GetFirst()
    while tc do
        att=bit.bor(att,tc:GetOriginalAttribute())
        tc=g:GetNext()
    end
    return att
end
function c60158607.efilter(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false
    else 
        if te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() then
            local Att=e:GetHandler():GetAttribute()
            local ec=te:GetOwner()
            return bit.band(ec:GetAttribute(),Att)~=0 
        else
            return false
        end
    end
end
function c60158607.efilter2(e,c)
    return e:GetHandler():GetAttribute()
end
function c60158607.scon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c60158607.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsRace(RACE_FIEND)
end
function c60158607.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158607.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60158607.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60158607.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
