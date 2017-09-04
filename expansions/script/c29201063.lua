--镜世录 古之邪仙
function c29201063.initial_effect(c)
    c:SetUniqueOnField(1,0,29201063)
    c:EnableUnsummonable()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c29201063.splimit)
    c:RegisterEffect(e1)
    --[[spsummon
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201063,0))
    e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e10:SetRange(LOCATION_HAND)
    e10:SetCode(EVENT_DESTROYED)
    e10:SetCondition(c29201063.spcon)
    e10:SetCost(c29201063.spcost)
    e10:SetTarget(c29201063.sptg)
    e10:SetOperation(c29201063.spop)
    c:RegisterEffect(e10)]]
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201063.splimit5)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_ONFIELD)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201063.splimit5)
    c:RegisterEffect(e13)
    --remove
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
    e11:SetType(EFFECT_TYPE_QUICK_O)
    e11:SetCode(EVENT_FREE_CHAIN)
    e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e11:SetRange(LOCATION_MZONE)
    e11:SetHintTiming(TIMING_DAMAGE_STEP)
    e11:SetCountLimit(1)
    e11:SetCondition(c29201063.condition)
    e11:SetTarget(c29201063.target)
    e11:SetOperation(c29201063.operation)
    c:RegisterEffect(e11)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c29201063.descon1)
    e2:SetCost(c29201063.spcost)
    e2:SetTarget(c29201063.sptg)
    e2:SetOperation(c29201063.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetCondition(c29201063.descon2)
    c:RegisterEffect(e3)
    --summon,flip
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_ONFIELD)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetOperation(c29201063.handes)
    c:RegisterEffect(e4)
end
function c29201063.splimit5(e,c)
    return not c:IsSetCard(0x63e0) 
end
c29201063[0]=0
function c29201063.handes(e,tp,eg,ep,ev,re,r,rp)
    local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
    if ep==tp or loc~=LOCATION_MZONE or id==c29201063[0] or not re:IsActiveType(TYPE_MONSTER) then return end
    c29201063[0]=id
    if Duel.CheckLPCost(1-tp,500) and Duel.SelectYesNo(1-tp,aux.Stringid(29201063,0)) then
        Duel.PayLPCost(1-tp,500)
        Duel.BreakEffect()
    else Duel.NegateEffect(ev) end
end
function c29201063.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x63e0) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201063.tgfilter(c,tp)
    return c:IsPreviousSetCard(0x63e0) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_MZONE) 
end
function c29201063.descon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201063.tgfilter,1,nil,tp)
end
function c29201063.descon2(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and eg:IsExists(c29201063.tgfilter,1,nil,tp)
end
function c29201063.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c29201063.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201063.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c29201063.cfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g1=Duel.SelectMatchingCard(tp,c29201063.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local g2=Duel.SelectMatchingCard(tp,c29201063.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
    g1:Merge(g2)
    Duel.Release(g1,REASON_COST)
end
function c29201063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201063.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c29201063.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c29201063.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29201063.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201063.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c29201063.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c29201063.filter,tp,LOCATION_ONFIELD,0,1,12,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c29201063.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoHand(rg,nil,REASON_EFFECT)
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.BreakEffect()
        local og=Duel.GetOperatedGroup()
        local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
        if ct>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
            e1:SetValue(ct*300)
            c:RegisterEffect(e1)
        end
    end
end

