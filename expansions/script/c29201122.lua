--辉耀团-魔操兽使 蒂娜
function c29201122.initial_effect(c)
    --fusion material
    aux.AddFusionProcFun2(c,c29201122.mfilter1,c29201122.mfilter2,true)
    c:EnableReviveLimit()
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c29201122.spcon)
    e2:SetOperation(c29201122.spop)
    c:RegisterEffect(e2)
    --search
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201122,0))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_SPSUMMON_SUCCESS)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e10:SetTarget(c29201122.thtg)
    e10:SetOperation(c29201122.tgop)
    c:RegisterEffect(e10)
    --Position+Negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201122,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1c0)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29201122.postg)
    e1:SetOperation(c29201122.posop)
    c:RegisterEffect(e1)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c29201122.thtg2)
    e3:SetOperation(c29201122.thop2)
    c:RegisterEffect(e3)
end
function c29201122.mfilter1(c)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201122.mfilter2(c)
    return c:GetLevel()==2 and c:IsType(TYPE_PENDULUM)
end
function c29201122.spfilter1(c,tp,fc)
    return (c:IsFusionSetCard(0x33e1) or c:IsFusionSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,c29201122.spfilter2,1,c,fc)
end
function c29201122.spfilter2(c,fc)
    return c:GetLevel()==2 and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c29201122.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
        and Duel.CheckReleaseGroup(tp,c29201122.spfilter1,1,nil,tp,c)
end
function c29201122.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,c29201122.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,c29201122.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c29201122.spfilter4(c) 
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsAbleToHand()
end
function c29201122.spfilter3(c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_PENDULUM)
end
function c29201122.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c29201122.spfilter4,tp,LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>=3
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c29201122.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c29201122.spfilter4,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg3=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.ConfirmCards(1-tp,sg1)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local cg=sg1:Select(1-tp,1,1,nil)
        local tc=cg:GetFirst()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        sg1:RemoveCard(tc)
        --Duel.SendtoGrave(sg1,REASON_EFFECT)
		Duel.SendtoExtraP(sg1,nil,REASON_EFFECT)
    end
end
function c29201122.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c29201122.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
    end
end
function c29201122.thfilter2(c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
        and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE))
end
function c29201122.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201122.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c29201122.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201122.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end


