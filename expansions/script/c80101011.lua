--刀术-绊
function c80101011.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,80101011)
    e1:SetCondition(c80101011.condition)
    e1:SetTarget(c80101011.target)
    e1:SetOperation(c80101011.activate)
    c:RegisterEffect(e1)
    --atk/def down
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80101011,0))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_HAND)
    e4:SetCountLimit(1,80101011)
    e4:SetCondition(c80101011.recon1)
    e4:SetCost(c80101011.atkcost)
    e4:SetTarget(c80101011.atktg)
    e4:SetOperation(c80101011.atkop)
    c:RegisterEffect(e4)
end
function c80101011.cfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101011.recon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c80101011.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c80101011.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80101011.filter1(c)
    return c:IsSetCard(0x6400) and c:IsSSetable()
end
function c80101011.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80101011.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function c80101011.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c80101011.filter1,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
        Duel.Damage(tp,500,REASON_EFFECT)
    end
end
function c80101011.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80101011.filter(c,e,tp)
    return c:IsSetCard(0x5400) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101011.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c80101011.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80101011.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80101011.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local tg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80101011,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
            local sg=tg:Select(tp,1,1,nil)
            Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
        end
    end
end
