--辉耀团-翠涡之戒 玛拉
function c29201130.initial_effect(c)
    --fusion material
    aux.AddFusionProcFun2(c,c29201130.mfilter1,c29201130.mfilter2,true)
    c:EnableReviveLimit()
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c29201130.spcon)
    e2:SetOperation(c29201130.spop)
    c:RegisterEffect(e2)
    --damage
    local e12=Effect.CreateEffect(c)
    e12:SetCategory(CATEGORY_DAMAGE)
    e12:SetType(EFFECT_TYPE_IGNITION)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCountLimit(1)
    e12:SetTarget(c29201130.damtg)
    e12:SetOperation(c29201130.damop)
    c:RegisterEffect(e12)
    --indes
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(LOCATION_MZONE,0)
    e11:SetTarget(c29201130.indtg)
    e11:SetValue(1)
    c:RegisterEffect(e11)
    local e8=e11:Clone()
    e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e8)
    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201130,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c29201130.condition)
    e3:SetTarget(c29201130.target)
    e3:SetOperation(c29201130.operation)
    c:RegisterEffect(e3)
end
function c29201130.mfilter1(c)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201130.mfilter2(c)
    return c:GetLevel()==10 and c:IsType(TYPE_PENDULUM)
end
function c29201130.spfilter1(c,tp,fc)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,c29201130.spfilter2,1,c,fc)
end
function c29201130.spfilter2(c,fc)
    return c:GetLevel()==10 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201130.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c29201130.spfilter1,1,nil,tp,c)
end
function c29201130.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c29201130.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,c29201130.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201130.filter(c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c29201130.ctfilter(c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c29201130.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201130.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
        and Duel.IsExistingMatchingCard(c29201130.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local ct=Duel.GetMatchingGroupCount(c29201130.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c29201130.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201130.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
        local ct=Duel.GetMatchingGroupCount(c29201130.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        Duel.Damage(p,ct*500,REASON_EFFECT)
    end
end
function c29201130.indtg(e,c)
    return not c:IsCode(29201130)
end
function c29201130.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c29201130.spfilter3(c,e,tp)
    return c:IsSetCard(0x33e1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c29201130.spfilter4,tp,LOCATION_DECK,0,1,c,e,tp)
end
function c29201130.spfilter4(c,e,tp)
    return c:IsSetCard(0x53e1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201130.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.IsExistingMatchingCard(c29201130.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c29201130.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
        or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c29201130.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,c29201130.spfilter4,tp,LOCATION_DECK,0,1,1,g1:GetFirst(),e,tp)
    g1:Merge(g2)
    if g1:GetCount()==2 then
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end

