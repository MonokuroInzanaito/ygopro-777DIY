--幻想物语 荆棘城堡的塔利娅
function c80100002.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon condition
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ea:SetCode(EFFECT_SPSUMMON_CONDITION)
    ea:SetValue(c80100002.splimit)
    c:RegisterEffect(ea)
    --spsummon limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c80100002.sumlimit)
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
    ec:SetDescription(aux.Stringid(80100002,1))
    ec:SetCategory(CATEGORY_POSITION)
    ec:SetType(EFFECT_TYPE_QUICK_O)
    ec:SetProperty(EFFECT_FLAG_CARD_TARGET)
    ec:SetCode(EVENT_CHAINING)
    ec:SetRange(LOCATION_MZONE)
    ec:SetCountLimit(1,80100002)
    ec:SetCondition(c80100002.chcon)
    ec:SetTarget(c80100002.chtg)
    ec:SetOperation(c80100002.chop)
    c:RegisterEffect(ec)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80100002,2))
    e2:SetCategory(CATEGORY_RELEASE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,80100002)
    e2:SetCost(c80100002.rlcost)
    e2:SetTarget(c80100002.rltg)
    e2:SetOperation(c80100002.rlop)
    c:RegisterEffect(e2)
end
function c80100002.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x3400) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80100002.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)
end
function c80100002.chcon(e,tp,eg,ep,ev,re,r,rp)
    --[[local rc=re:GetHandler()
    return rc:GetType()==TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE)]]
    local tpe=re:GetActiveType()
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tpe==TYPE_QUICKPLAY+TYPE_SPELL and e:GetHandler():GetFlagEffect(1)>0
end
function c80100002.filter(c)
    return c:IsFaceup() and c:IsCanTurnSet() and not c:IsStatus(STATUS_LEAVE_CONFIRMED) and c:GetSequence()~=6 and c:GetSequence()~=7
end
function c80100002.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c80100002.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80100002.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c80100002.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c80100002.chop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
            Duel.ChangePosition(tc,POS_FACEDOWN)
            Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		else
            Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
        end
	end
end
function c80100002.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,600) end
    Duel.PayLPCost(tp,600)
end
function c80100002.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsReleasable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectTarget(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c80100002.rlop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Release(tc,REASON_EFFECT)
    end
end
