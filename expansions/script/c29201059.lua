--镜世录 萨那度
function c29201059.initial_effect(c)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c29201059.spcon)
    e2:SetOperation(c29201059.spop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201059,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCost(c29201059.thcost)
    e3:SetTarget(c29201059.thtg)
    e3:SetOperation(c29201059.thop)
    c:RegisterEffect(e3)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201059,2))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201059.pencon)
    e7:SetTarget(c29201059.pentg)
    e7:SetOperation(c29201059.penop)
    c:RegisterEffect(e7)
    --activate limit
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e11:SetCode(EVENT_CHAINING)
    e11:SetRange(LOCATION_ONFIELD)
    e11:SetOperation(c29201059.aclimit1)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e12:SetCode(EVENT_CHAIN_NEGATED)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetOperation(c29201059.aclimit2)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_ACTIVATE)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_ONFIELD)
    e13:SetTargetRange(0,1)
    e13:SetCondition(c29201059.econ)
    e13:SetValue(c29201059.elimit)
    c:RegisterEffect(e13)
end
function c29201059.aclimit1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    e:GetHandler():RegisterFlagEffect(29201059,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c29201059.aclimit2(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    e:GetHandler():ResetFlagEffect(29201059)
end
function c29201059.econ(e)
    return e:GetHandler():GetFlagEffect(29201059)~=0
end
function c29201059.elimit(e,te,tp)
    return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c29201059.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c29201059.thfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29201059.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c29201059.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201059.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c29201059.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29201059.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c29201059.spcfilter(c)
    return c:IsSetCard(0x63e0) and not c:IsPublic()
end
function c29201059.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local hg=Duel.GetMatchingGroup(c29201059.spcfilter,tp,LOCATION_HAND,0,c)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetClassCount(Card.GetCode)>=3
end
function c29201059.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local hg=Duel.GetMatchingGroup(c29201059.spcfilter,tp,LOCATION_HAND,0,c)
    local rg=Group.CreateGroup()
    for i=1,3 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local g=hg:Select(tp,1,1,nil)
        local tc=g:GetFirst()
        rg:AddCard(tc)
        hg:Remove(Card.IsCode,nil,tc:GetCode())
    end
    Duel.ConfirmCards(1-tp,rg)
    Duel.ShuffleHand(tp)
end
function c29201059.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201059.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201059.penop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
end
