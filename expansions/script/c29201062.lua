--镜世录 黑死花
function c29201062.initial_effect(c)
    c:SetUniqueOnField(1,0,29201062)
    c:EnableUnsummonable()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c29201062.splimit)
    c:RegisterEffect(e1)
    --tohand
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29201062,0))
    e8:SetCategory(CATEGORY_TOHAND)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e8:SetCountLimit(1,29201062)
    e8:SetTarget(c29201062.target)
    e8:SetOperation(c29201062.operation)
    c:RegisterEffect(e8)
    --spsummon
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201062,0))
    e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e10:SetRange(LOCATION_HAND)
    e10:SetCode(EVENT_DESTROYED)
    e10:SetCondition(c29201062.spcon)
    e10:SetCost(c29201062.spcost)
    e10:SetTarget(c29201062.sptg)
    e10:SetOperation(c29201062.spop)
    c:RegisterEffect(e10)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201062.splimit5)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201062.splimit5)
    c:RegisterEffect(e13)
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c29201062.damcon)
    e3:SetOperation(c29201062.damop)
    c:RegisterEffect(e3)
end
function c29201062.splimit5(e,c)
    return not c:IsSetCard(0x63e0) 
end
function c29201062.cfilter(c,tp)
    return c:GetSummonPlayer()==tp
end
function c29201062.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:IsExists(c29201062.cfilter,1,e:GetHandler(),1-tp)
end
function c29201062.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,29201062)
    Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500)
end
function c29201062.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x63e0) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201062.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29201062.costchk(e,te_or_c,tp)
    return Duel.CheckLPCost(tp,500)
end
function c29201062.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.PayLPCost(tp,500)
end
function c29201062.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201062.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c29201062.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
    Duel.SetChainLimit(c29201062.chlimit)
end
function c29201062.chlimit(e,ep,tp)
    return tp==ep
end
function c29201062.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c29201062.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c29201062.spfilter(c,tp)
    return c:IsPreviousSetCard(0x63e0) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
        and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)
end
function c29201062.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201062.spfilter,1,nil,tp)
end
function c29201062.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c29201062.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201062.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c29201062.cfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g1=Duel.SelectMatchingCard(tp,c29201062.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local g2=Duel.SelectMatchingCard(tp,c29201062.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
    g1:Merge(g2)
    Duel.Release(g1,REASON_COST)
end
function c29201062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201062.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
