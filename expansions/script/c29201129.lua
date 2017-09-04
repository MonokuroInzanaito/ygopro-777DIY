--辉耀团-苍海战姬 海洛伊丝
function c29201129.initial_effect(c)
    --fusion material
    aux.AddFusionProcFun2(c,c29201129.mfilter1,c29201129.mfilter2,true)
    c:EnableReviveLimit()
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c29201129.spcon)
    e2:SetOperation(c29201129.spop)
    c:RegisterEffect(e2)
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201129,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c29201129.rmtg)
    e1:SetOperation(c29201129.rmop)
    c:RegisterEffect(e1)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,29201129)
    e3:SetCondition(c29201129.spcon1)
    e3:SetTarget(c29201129.sptg)
    e3:SetOperation(c29201129.spop1)
    c:RegisterEffect(e3)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201129,4))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,29201229)
    e4:SetCondition(c29201129.thcon)
    e4:SetTarget(c29201129.thtg)
    e4:SetOperation(c29201129.thop)
    c:RegisterEffect(e4)
    local e8=e4:Clone()
    e8:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e8)
    local e9=e4:Clone()
    e9:SetCode(EVENT_TO_DECK)
    c:RegisterEffect(e9)
end
function c29201129.mfilter1(c)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201129.mfilter2(c)
    return c:GetLevel()==9 and c:IsType(TYPE_PENDULUM)
end
function c29201129.spfilter1(c,tp,fc)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,c29201129.spfilter2,1,c,fc)
end
function c29201129.spfilter2(c,fc)
    return c:GetLevel()==9 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201129.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c29201129.spfilter1,1,nil,tp,c)
end
function c29201129.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c29201129.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,c29201129.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201129.rmfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c29201129.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201129.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c29201129.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c29201129.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c29201129.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c29201129.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c29201129.filter(c,e,tp)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1) or c:IsSetCard(0x93e1)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201129.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c29201129.filter(chkc,e,tp) end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingTarget(c29201129.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c29201129.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c29201129.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsDefensePos() then return end
    Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()==0 then return end
    if g:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,ft,ft,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    else
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c29201129.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201129.thfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c29201129.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c29201129.thfilter,tp,LOCATION_EXTRA,0,nil)
    if chk==0 then return g:CheckWithSumEqual(Card.GetLevel,9,1,3) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c29201129.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c29201129.thfilter,tp,LOCATION_EXTRA,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:SelectWithSumEqual(tp,Card.GetLevel,9,1,3)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end

