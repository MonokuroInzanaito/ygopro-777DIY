--地耀团-结晶魔法使 优娜
function c29201109.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201109.reptg)
    ea:SetValue(c29201109.repval)
    ea:SetOperation(c29201109.repop)
    c:RegisterEffect(ea)
    --pos
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201109,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,0x1e0)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c29201109.target)
    e1:SetOperation(c29201109.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c29201109.tg)
    e2:SetValue(600)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DEFENSE_ATTACK)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c29201109.atktg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --draw
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(29201109,1))
    e12:SetCategory(CATEGORY_DRAW)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e12:SetCode(EVENT_CHANGE_POS)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCountLimit(1)
    e12:SetCondition(c29201109.drcon)
    e12:SetTarget(c29201109.drtg)
    e12:SetOperation(c29201109.drop)
    c:RegisterEffect(e12)
end
function c29201109.cfilter(c,tp)
    local np=c:GetPosition()
    local pp=c:GetPreviousPosition()
    return c:IsSetCard(0x33e1) and c:IsControler(tp) and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1))
end
function c29201109.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201109.cfilter,1,nil,tp)
end
function c29201109.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29201109.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c29201109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c29201109.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201109.tg(e,c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1))
end
function c29201109.atktg(e,c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1))
end
function c29201109.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x33e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201109.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201109.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201109,3))
end
function c29201109.repval(e,c)
    return c29201109.repfilter(c,e:GetHandlerPlayer())
end
function c29201109.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end