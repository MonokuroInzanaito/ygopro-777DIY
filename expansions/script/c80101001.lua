--刀魂-骨喰
function c80101001.initial_effect(c)
    --special summon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_DECK)
    e1:SetCountLimit(3,81101101)
    e1:SetCondition(c80101001.spcon)
    e1:SetOperation(c80101001.spop)
    c:RegisterEffect(e1)
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101001,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,80101001)
    e2:SetCondition(c80101001.eqcon)
    e2:SetTarget(c80101001.eqtg)
    e2:SetOperation(c80101001.eqop)
    c:RegisterEffect(e2)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80101001,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,80101001)
    e4:SetCost(c80101001.spcost)
    e4:SetTarget(c80101001.sptg)
    e4:SetOperation(c80101001.spop1)
    c:RegisterEffect(e4)
end
function c80101001.spfilter1(c)
    return c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,80101006)
end
function c80101001.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c80101001.spfilter1,1,nil)
end
function c80101001.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c80101001.spfilter1,1,1,nil)
    Duel.Release(g,REASON_COST)
    Duel.ShuffleDeck(tp)
end
function c80101001.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE+LOCATION_DECK)
end
function c80101001.thfilter(c)
    return c:IsSetCard(0x6400) and not c:IsCode(80101006) and c:IsAbleToHand()
end
function c80101001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101001.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c80101001.eqop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101001.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_DISCARD+REASON_COST,nil)
end
function c80101001.spfilter(c,e,tp)
    return c:IsSetCard(0x5400) and not c:IsCode(80101001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c80101001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80101001.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80101001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
