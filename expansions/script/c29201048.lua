--镜世录 有顶天变
function c29201048.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
    c:EnableReviveLimit()
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201048,3))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201048.pencon)
    e7:SetTarget(c29201048.pentg)
    e7:SetOperation(c29201048.penop)
    c:RegisterEffect(e7)
    --damage&recover
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29201048,0))
    e8:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DAMAGE_STEP_END)
    e8:SetTarget(c29201048.damtg)
    e8:SetOperation(c29201048.damop)
    c:RegisterEffect(e8)
    --mat check
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(c29201048.matcheck)
    c:RegisterEffect(e1)
    --act limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c29201048.regcon)
    e2:SetOperation(c29201048.regop)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x63e0))
    e3:SetValue(c29201048.indesval)
    c:RegisterEffect(e3)
end
function c29201048.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetAttackTarget()~=nil end
    local c=e:GetHandler()
    local d=Duel.GetAttackTarget()
    if d==c then d=Duel.GetAttacker() end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetDefense())
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,d:GetAttack())
end
function c29201048.damop(e,tp,eg,ep,ev,re,r,rp)
    local ex1,a1,b1,p1,d1=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
    local ex2,a2,b2,p2,d2=Duel.GetOperationInfo(0,CATEGORY_RECOVER)
    Duel.Damage(1-tp,d1,REASON_EFFECT,true)
    Duel.Recover(tp,d2,REASON_EFFECT,true)
    Duel.RDComplete()
end
function c29201048.indesval(e,re,r,rp)
    return bit.band(r,REASON_RULE+REASON_BATTLE)==0
end
function c29201048.matcheck(e,c)
    local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0x63e0)
    local rac=0
    local tc=g:GetFirst()
    while tc do
        rac=bit.bor(rac,tc:GetOriginalRace())
        tc=g:GetNext()
    end
    e:SetLabel(rac)
end
function c29201048.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c29201048.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(c29201048.aclimit)
    e1:SetLabelObject(e:GetLabelObject())
    c:RegisterEffect(e1)
end
function c29201048.aclimit(e,re,tp)
    local att=e:GetLabelObject():GetLabel()
    return re:IsActiveType(TYPE_MONSTER) and bit.band(att,re:GetHandler():GetOriginalRace())~=0
        and not re:GetHandler():IsImmuneToEffect(e)
end
function c29201048.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201048.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201048.penop(e,tp,eg,ep,ev,re,r,rp)
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
