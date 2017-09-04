--幻想物语 向往恋爱的爱丽尔
function c80100004.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon condition
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ea:SetCode(EFFECT_SPSUMMON_CONDITION)
    ea:SetValue(c80100004.splimit)
    c:RegisterEffect(ea)
    --spsummon limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c80100004.sumlimit)
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
    ec:SetDescription(aux.Stringid(80100004,1))
    ec:SetCategory(CATEGORY_SPECIAL_SUMMON)
    ec:SetType(EFFECT_TYPE_QUICK_O)
    ec:SetCode(EVENT_CHAINING)
    ec:SetRange(LOCATION_MZONE)
    ec:SetCountLimit(1,80100004)
    ec:SetCondition(c80100004.chcon)
    ec:SetTarget(c80100004.chtg)
    ec:SetOperation(c80100004.chop)
    c:RegisterEffect(ec)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80100004,2))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,80100004)
    e2:SetCost(c80100004.rlcost)
    e2:SetTarget(c80100004.rltg)
    e2:SetOperation(c80100004.rlop)
    c:RegisterEffect(e2)
end
function c80100004.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x3400) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80100004.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)
end
function c80100004.chcon(e,tp,eg,ep,ev,re,r,rp)
    --[[local rc=re:GetHandler()
    return rc:GetType()==TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE)]]
    local tpe=re:GetActiveType()
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tpe==TYPE_QUICKPLAY+TYPE_SPELL and e:GetHandler():GetFlagEffect(1)>0
end
function c80100004.filter(c,e,tp)
    return c:IsSetCard(0x3400) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80100004.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c80100004.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80100004.chop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80100004.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
        local atk=tc:GetAttack()
        if atk<0 then atk=0 end
        Duel.Damage(tp,atk,REASON_EFFECT)
    end
end
function c80100004.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,200) end
    Duel.PayLPCost(tp,200)
end
function c80100004.tdfilter(c)
    return c:IsAbleToDeck()
end
function c80100004.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c80100004.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80100004.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c80100004.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c80100004.rlop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.Recover(tp,1500,REASON_EFFECT)
    end
end

