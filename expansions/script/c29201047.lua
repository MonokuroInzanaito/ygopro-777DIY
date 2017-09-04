--镜世录 诅咒之子
function c29201047.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
    c:EnableReviveLimit()
    --destroy
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29201047,0))
    e8:SetCategory(CATEGORY_DESTROY)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_BATTLE_START)
    e8:SetTarget(c29201047.destg1)
    e8:SetOperation(c29201047.desop1)
    c:RegisterEffect(e8)
    --cannot set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetTargetRange(1,1)
    e2:SetCondition(c29201047.effcon)
    c:RegisterEffect(e2)
    --cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e3:SetTarget(c29201047.distg)
    e3:SetCondition(c29201047.effcon)
    c:RegisterEffect(e3)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201047,3))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201047.pencon)
    e7:SetTarget(c29201047.pentg)
    e7:SetOperation(c29201047.penop)
    c:RegisterEffect(e7)
end
function c29201047.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201047.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201047.penop(e,tp,eg,ep,ev,re,r,rp)
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
function c29201047.effcon(e)
    return not Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c29201047.distg(e,c)
    return c:IsFacedown()
end
function c29201047.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetBattleTarget()
    if chk==0 then return tc and tc:IsFaceup() and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and not tc:IsType(TYPE_PENDULUM) end
end
function c29201047.desop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() then
        Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(tc)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
end
