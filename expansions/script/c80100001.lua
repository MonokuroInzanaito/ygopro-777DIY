--幻想物语 奇迹之国的爱丽丝
function c80100001.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon condition
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ea:SetCode(EFFECT_SPSUMMON_CONDITION)
    ea:SetValue(c80100001.splimit)
    c:RegisterEffect(ea)
    --spsummon limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c80100001.sumlimit)
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
    ec:SetDescription(aux.Stringid(80100001,1))
    ec:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    ec:SetType(EFFECT_TYPE_QUICK_O)
    ec:SetCode(EVENT_CHAINING)
    ec:SetRange(LOCATION_MZONE)
    ec:SetCountLimit(1,80100001)
    ec:SetCondition(c80100001.chcon)
    ec:SetTarget(c80100001.chtg)
    ec:SetOperation(c80100001.chop)
    c:RegisterEffect(ec)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80100001,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,80100001)
    e2:SetCost(c80100001.rlcost)
    e2:SetTarget(c80100001.rltg)
    e2:SetOperation(c80100001.rlop)
    c:RegisterEffect(e2)
end
function c80100001.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x3400) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80100001.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)
end
function c80100001.chcon(e,tp,eg,ep,ev,re,r,rp)
    --[[local rc=re:GetHandler()
    return rc:GetType()==TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE)]]
    local tpe=re:GetActiveType()
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tpe==TYPE_QUICKPLAY+TYPE_SPELL and e:GetHandler():GetFlagEffect(1)>0
end
function c80100001.thfilter(c)
    return c:IsSetCard(0x3400) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c80100001.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80100001.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80100001.chop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80100001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end
function c80100001.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c80100001.setfilter(c)
    return c:IsSetCard(0x3400) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c80100001.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80100001.setfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80100001.setfilter,tp,LOCATION_GRAVE,0,1,nil) 
	    and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectTarget(tp,c80100001.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c80100001.rlop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable() then
        Duel.SSet(tp,tc)
        Duel.ConfirmCards(1-tp,tc)
    end
end


