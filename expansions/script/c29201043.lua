--镜世录 龙宫使
function c29201043.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),4,2)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201043,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c29201043.indcon)
    e2:SetTarget(c29201043.indtg)
    e2:SetOperation(c29201043.indop)
    c:RegisterEffect(e2)
    --set
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(29201043,1))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c29201043.settg)
    e5:SetOperation(c29201043.setop)
    c:RegisterEffect(e5)
    --spsummon limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    e3:SetTarget(c29201043.sumlimit)
    c:RegisterEffect(e3)
    --act limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_PZONE)
    e4:SetOperation(c29201043.chainop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e5)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201043,5))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201043.pencon)
    e7:SetTarget(c29201043.pentg)
    e7:SetOperation(c29201043.penop)
    c:RegisterEffect(e7)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1,0)
    e12:SetCondition(c29201043.splimcon)
    e12:SetTarget(c29201043.splimit)
    c:RegisterEffect(e12)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201043,2))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c29201043.atkcon)
    e1:SetCost(c29201043.adcost)
    e1:SetTarget(c29201043.atktg)
    e1:SetOperation(c29201043.atkop)
    c:RegisterEffect(e1)
end
function c29201043.filter8(c)
    return c:IsSetCard(0x63e0) 
end
function c29201043.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201043.filter8,1,nil)
end
function c29201043.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29201043.filter(c,ft)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
	   and (c:IsAbleToHand() or (ft>0))
end
function c29201043.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29201043.filter(chkc) end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if chk==0 then return Duel.IsExistingTarget(c29201043.filter,tp,LOCATION_GRAVE,0,1,nil,ft) end
    local g=Duel.SelectTarget(tp,c29201043.filter,tp,LOCATION_GRAVE,0,1,1,nil,ft)
    local th=g:GetFirst():IsAbleToHand()
    local sp=ft>0 
    if th and sp then 
		op=Duel.SelectOption(tp,aux.Stringid(29201043,2),aux.Stringid(29201043,3))
    elseif th then 
		op=0
    else 
		op=1 
	end
    e:SetLabel(op)
end
function c29201043.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    --[[if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end]]
    if e:GetLabel()==0 then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    else
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
function c29201043.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return se:IsActiveType(TYPE_SPELL+TYPE_TRAP) and se:IsHasType(EFFECT_TYPE_ACTIONS) 
end
function c29201043.chainop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimit(aux.FALSE)
end
c29201043.pendulum_level=4
function c29201043.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201043.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c29201043.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29201043.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c29201043.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x63e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201043.setfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
end
function c29201043.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c29201043.setfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c29201043.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectTarget(tp,c29201043.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c29201043.setop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
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
function c29201043.cfilter(c,e,tp)
    return c:IsSetCard(0x63e0) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
        and (not e or c:IsRelateToEffect(e))
end
function c29201043.indcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201043.cfilter,1,nil,nil,tp)
end
function c29201043.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
end
function c29201043.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Filter(c29201043.cfilter,nil,e,tp)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
