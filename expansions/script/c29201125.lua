--辉耀团-白圣公主 萝瑞尔
function c29201125.initial_effect(c)
    --fusion material
    aux.AddFusionProcFun2(c,c29201125.mfilter1,c29201125.mfilter2,true)
    c:EnableReviveLimit()
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c29201125.spcon)
    e2:SetOperation(c29201125.spop)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(c29201125.distg)
    e3:SetOperation(c29201125.disop)
    c:RegisterEffect(e3)
    --draw(spsummon)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29201125,0))
    e8:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetTarget(c29201125.target)
    e8:SetOperation(c29201125.operation)
    c:RegisterEffect(e8)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201125,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCountLimit(1,29201125)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(c29201125.spcon1)
    e1:SetTarget(c29201125.sptg1)
    e1:SetOperation(c29201125.spop1)
    c:RegisterEffect(e1)
end
function c29201125.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29201125.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)~=0 then
        local tc=Duel.GetOperatedGroup():GetFirst()
        Duel.ConfirmCards(1-tp,tc)
        Duel.BreakEffect()
        if tc:IsType(TYPE_MONSTER) and (tc:IsSetCard(0x33e1) or tc:IsSetCard(0x53e1)) then
            if tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
                and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
                and Duel.SelectYesNo(tp,aux.Stringid(29201125,1)) then
                Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
            end
        else
            Duel.SendtoGrave(tc,REASON_EFFECT)
        end
        Duel.ShuffleHand(tp)
    end
end
function c29201125.mfilter1(c)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201125.mfilter2(c)
    return c:GetLevel()==5 and c:IsType(TYPE_PENDULUM)
end
function c29201125.spfilter1(c,tp,fc)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,c29201125.spfilter2,1,c,fc)
end
function c29201125.spfilter2(c,fc)
    return c:GetLevel()==5 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201125.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c29201125.spfilter1,1,nil,tp,c)
end
function c29201125.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c29201125.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,c29201125.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201125.disfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c29201125.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c29201125.disfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201125.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c29201125.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c29201125.disop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
    local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc1=g1:GetFirst()
    if tc1 then
        Duel.BreakEffect()
        Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201125.spcon1(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    return tc1 and (tc1:IsSetCard(0x33e1) or tc1:IsSetCard(0x53e1)) and tc2 and (tc2:IsSetCard(0x33e1) or tc2:IsSetCard(0x53e1))
end
function c29201125.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201125.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1,true)
    elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end

