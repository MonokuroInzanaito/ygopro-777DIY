--镜世录 一寸法师
function c29201024.initial_effect(c)
    --lv change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201024,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(2)
    e1:SetTarget(c29201024.target)
    e1:SetOperation(c29201024.operation)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c29201024.reptg)
    e2:SetValue(c29201024.repval)
    e2:SetOperation(c29201024.repop)
    c:RegisterEffect(e2)
    --lp rec
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201024,4))
    e10:SetCategory(CATEGORY_RECOVER)
    e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e10:SetProperty(EFFECT_FLAG_DELAY)
    e10:SetRange(LOCATION_SZONE)
    e10:SetCode(EVENT_DESTROY)
    e10:SetCondition(c29201024.reccon)
    e10:SetTarget(c29201024.rectg)
    e10:SetOperation(c29201024.recop)
    c:RegisterEffect(e10)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201024,2))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201024.pencon)
    e7:SetTarget(c29201024.pentg)
    e7:SetOperation(c29201024.penop)
    c:RegisterEffect(e7)
end
function c29201024.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsLevelAbove(1)
end
function c29201024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c29201024.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c29201024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    local op=0
    if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(29201024,1))
    else op=Duel.SelectOption(tp,aux.Stringid(29201024,1),aux.Stringid(29201024,2)) end
    e:SetLabel(op)
end
function c29201024.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        if e:GetLabel()==0 then
            e1:SetValue(1)
        else e1:SetValue(-1) end
        tc:RegisterEffect(e1)
    local e10=Effect.CreateEffect(e:GetHandler())
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e10:SetTargetRange(1,0)
    e10:SetTarget(c29201024.splimit)
    e10:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e10,tp)
	end
end
function c29201024.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201024.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x63e0)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201024.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201024.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201024,3))
end
function c29201024.repval(e,c)
    return c29201024.repfilter(c,e:GetHandlerPlayer())
end
function c29201024.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201024.filter4(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) 
end
function c29201024.reccon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201024.filter4,1,nil,tp)
end
function c29201024.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c29201024.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c29201024.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201024.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201024.penop(e,tp,eg,ep,ev,re,r,rp)
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
