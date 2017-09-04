--镜世录 苏我氏的亡灵
function c29201056.initial_effect(c)
    --return to Spell
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201056,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetCountLimit(1,29201056)
    e4:SetCost(c29201056.cost)
    e4:SetTarget(c29201056.target)
    e4:SetOperation(c29201056.op)
    c:RegisterEffect(e4)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201056.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_ONFIELD)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201056.splimit)
    c:RegisterEffect(e13)
    --synchro effect
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
    e2:SetCountLimit(1)
    e2:SetCondition(c29201056.sccon)
    e2:SetTarget(c29201056.sctg)
    e2:SetOperation(c29201056.scop)
    c:RegisterEffect(e2)
end
function c29201056.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c29201056.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201056.recfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsType(TYPE_SPELL)
end
function c29201056.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
        local ct=Duel.GetMatchingGroupCount(c29201056.recfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if ct>0 then
            Duel.Recover(tp,ct*500,REASON_EFFECT)
        end
    end
end
function c29201056.sccon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()==tp then return false end
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c29201056.mfilter(c)
    return c:IsSetCard(0x63e0)
end
function c29201056.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(c29201056.mfilter,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29201056.scop(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetMatchingGroup(c29201056.mfilter,tp,LOCATION_MZONE,0,nil)
    local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
    end
end

