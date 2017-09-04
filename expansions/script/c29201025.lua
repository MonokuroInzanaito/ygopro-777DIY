--镜世录 雪月风花
function c29201025.initial_effect(c)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c29201025.spcon)
    e2:SetOperation(c29201025.spop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetValue(c29201025.atkval)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(c29201025.atkval)
    c:RegisterEffect(e4)
    --Extra Attack
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetCondition(aux.bdcon)
    e5:SetTarget(c29201025.atktg)
    e5:SetOperation(c29201025.atkop)
    c:RegisterEffect(e5)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201025,2))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201025.pencon)
    e7:SetTarget(c29201025.pentg)
    e7:SetOperation(c29201025.penop)
    c:RegisterEffect(e7)
    --reflect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetTargetRange(LOCATION_MZONE,0)
    e12:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
    e12:SetTarget(c29201025.reftg)
    e12:SetValue(1)
    c:RegisterEffect(e12)
end
function c29201025.reftg(e,c)
    return c:IsSetCard(0x63e0)
end
function c29201025.spcfilter(c)
    return c:IsSetCard(0x63e0) and not c:IsPublic()
end
function c29201025.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local hg=Duel.GetMatchingGroup(c29201025.spcfilter,tp,LOCATION_HAND,0,c)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hg:GetClassCount(Card.GetCode)>=3
end
function c29201025.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local hg=Duel.GetMatchingGroup(c29201025.spcfilter,tp,LOCATION_HAND,0,c)
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
function c29201025.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xd8)
end
function c29201025.atkval(e,c)
    return Duel.GetMatchingGroupCount(c29201025.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*-100
end
function c29201025.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201025.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201025.penop(e,tp,eg,ep,ev,re,r,rp)
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
function c29201025.cfilter1(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
end
function c29201025.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201025.cfilter1,tp,LOCATION_DECK,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201025.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c29201025.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
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


