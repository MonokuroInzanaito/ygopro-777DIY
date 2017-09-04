--幻想物语 归去月球的辉夜姬
function c80100005.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon condition
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ea:SetCode(EFFECT_SPSUMMON_CONDITION)
    ea:SetValue(c80100005.splimit)
    c:RegisterEffect(ea)
    --spsummon limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c80100005.sumlimit)
    c:RegisterEffect(e3)
    --
    local eb=Effect.CreateEffect(c)
    eb:SetType(EFFECT_TYPE_SINGLE)
    eb:SetCode(EFFECT_UNRELEASABLE_SUM)
    eb:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    eb:SetRange(LOCATION_MZONE)
    eb:SetValue(1)
    c:RegisterEffect(eb)
    --atkup
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e8:SetCode(EVENT_CHAINING)
    e8:SetRange(LOCATION_MZONE)
    e8:SetOperation(aux.chainreg)
    c:RegisterEffect(e8)
    --change effect
    local ec=Effect.CreateEffect(c)
    ec:SetDescription(aux.Stringid(80100005,1))
    ec:SetCategory(CATEGORY_DISABLE)
    ec:SetType(EFFECT_TYPE_QUICK_O)
    ec:SetProperty(EFFECT_FLAG_CARD_TARGET)
    ec:SetCode(EVENT_CHAINING)
    ec:SetRange(LOCATION_MZONE)
    ec:SetCountLimit(1,80100005)
    ec:SetCondition(c80100005.chcon)
    ec:SetTarget(c80100005.chtg)
    ec:SetOperation(c80100005.chop)
    c:RegisterEffect(ec)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80100005,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,80100005)
    e2:SetCost(c80100005.rlcost)
    e2:SetTarget(c80100005.rltg)
    e2:SetOperation(c80100005.rlop)
    c:RegisterEffect(e2)
end
function c80100005.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x3400) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80100005.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)
end
function c80100005.chcon(e,tp,eg,ep,ev,re,r,rp)
    --[[local rc=re:GetHandler()
    return rc:GetType()==TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE)]]
    local tpe=re:GetActiveType()
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tpe==TYPE_QUICKPLAY+TYPE_SPELL and e:GetHandler():GetFlagEffect(1)>0
end
function c80100005.filter(c)
    return c:IsFaceup() and not c:IsDisabled()
end
function c80100005.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80100005.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80100005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c80100005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
    end
end
function c80100005.chop(e,tp,eg,ep,ev,re,r,rp)
    local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if hg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12152769,2)) then
        Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(12152769,3))
        local sg=hg:Select(1-tp,1,1,nil)
        Duel.SendtoHand(sg,tp,REASON_EFFECT)
        if Duel.IsChainDisablable(0) then
            Duel.NegateEffect(0)
            return
        end
    end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetValue(RESET_TURN_SET)
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end
function c80100005.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,400) end
    Duel.PayLPCost(tp,400)
end
function c80100005.filter8(c,e,tp)
    return c:IsSetCard(0x3400) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80100005.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c80100005.filter8,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80100005.rlop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80100005.filter8,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
        Duel.BreakEffect()
        --Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.Destroy(tc,REASON_EFFECT)
    end
end


