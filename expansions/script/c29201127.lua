--辉耀团-神界骑士 塞西莉亚
function c29201127.initial_effect(c)
    --fusion material
    aux.AddFusionProcFun2(c,c29201127.mfilter1,c29201127.mfilter2,true)
    c:EnableReviveLimit()
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c29201127.spcon)
    e2:SetOperation(c29201127.spop)
    c:RegisterEffect(e2)
    --pos
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(29201127,0))
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_BE_BATTLE_TARGET)
    e5:SetTarget(c29201127.target)
    e5:SetOperation(c29201127.operation)
    c:RegisterEffect(e5)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c29201127.spcon7)
    e1:SetTarget(c29201127.sptg7)
    e1:SetOperation(c29201127.spop7)
    c:RegisterEffect(e1)
end
function c29201127.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c29201127.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c29201127.mfilter1(c)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201127.mfilter2(c)
    return c:GetLevel()==7 and c:IsType(TYPE_PENDULUM)
end
function c29201127.spfilter1(c,tp,fc)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,c29201127.spfilter2,1,c,fc)
end
function c29201127.spfilter2(c,fc)
    return c:GetLevel()==7 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201127.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c29201127.spfilter1,1,nil,tp,c)
end
function c29201127.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c29201127.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,c29201127.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201127.spcon7(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsContains(e:GetHandler())
end
function c29201127.spfilter(c,e,tp)
    return c:IsCode(29201127) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c29201127.sptg7(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201127.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c29201127.spop7(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201127.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end
