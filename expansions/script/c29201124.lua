--辉耀团-大海贤将 艾谱莉
function c29201124.initial_effect(c)
    --fusion material
    aux.AddFusionProcFun2(c,c29201124.mfilter1,c29201124.mfilter2,true)
    c:EnableReviveLimit()
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c29201124.spcon)
    e2:SetOperation(c29201124.spop)
    c:RegisterEffect(e2)
    --battle indestructable
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e10:SetValue(1)
    c:RegisterEffect(e10)
    --position change
    local e12=Effect.CreateEffect(c)
    e12:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e12:SetCode(EVENT_SPSUMMON_SUCCESS)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCountLimit(1)
    e12:SetTarget(c29201124.postg)
    e12:SetOperation(c29201124.posop)
    c:RegisterEffect(e12)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,29201124)
    e3:SetCondition(c29201124.condition)
    e3:SetTarget(c29201124.target)
    e3:SetOperation(c29201124.operation)
    c:RegisterEffect(e3)
end
function c29201124.mfilter1(c)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201124.mfilter2(c)
    return c:GetLevel()==4 and c:IsType(TYPE_PENDULUM)
end
function c29201124.spfilter1(c,tp,fc)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,c29201124.spfilter2,1,c,fc)
end
function c29201124.spfilter2(c,fc)
    return c:GetLevel()==4 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201124.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c29201124.spfilter1,1,nil,tp,c)
end
function c29201124.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c29201124.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,c29201124.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201124.filter(c,sp)
    return c:GetSummonPlayer()==sp
end
function c29201124.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201124.filter,1,nil,1-tp) end
    local g=eg:Filter(c29201124.filter,nil,1-tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c29201124.posop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    local og=Duel.GetOperatedGroup()
    local tc=og:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        tc=og:GetNext()
    end
end
function c29201124.filter5(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT)
        and (c:IsSetCard(0x53e1) or c:IsSetCard(0x33e1)) and c:GetPreviousControler()==tp
        and ((c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP))
        or (c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)))
end
function c29201124.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201124.filter5,1,nil,tp)
end
function c29201124.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201124.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
