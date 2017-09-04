--凋叶棕-Star seeker
function c29200118.initial_effect(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200118,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c29200118.target)
    e1:SetOperation(c29200118.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200118,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c29200118.spcost)
    e3:SetTarget(c29200118.sptg)
    e3:SetOperation(c29200118.spop)
    c:RegisterEffect(e3)
    --to grave
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(29200118,2))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,29200118)
    e5:SetTarget(c29200118.tgtg)
    e5:SetOperation(c29200118.tgop)
    c:RegisterEffect(e5)
end
function c29200118.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
function c29200118.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.SortDecktop(tp,tp,3)
end
function c29200118.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c29200118.filter(c,e,tp)
    return c:IsSetCard(0x53e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29200118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200118.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29200118.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29200118.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c29200118.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200118.tgop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x53e0) and tc:IsAbleToHand()) then
        Duel.DisableShuffleCheck()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ShuffleHand(tp)
    else
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
    end
end

