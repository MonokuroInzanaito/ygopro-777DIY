--天辉团-圣钟歌姬 克莉丝汀
function c29201112.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201112.reptg)
    ea:SetValue(c29201112.repval)
    ea:SetOperation(c29201112.repop)
    c:RegisterEffect(ea)
    --splimit
    local ec=Effect.CreateEffect(c)
    ec:SetType(EFFECT_TYPE_FIELD)
    ec:SetRange(LOCATION_PZONE)
    ec:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    ec:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    ec:SetTargetRange(1,0)
    ec:SetTarget(c29201112.splimit)
    c:RegisterEffect(ec)
    --Disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetTarget(c29201112.destg)
    e2:SetOperation(c29201112.desop)
    c:RegisterEffect(e2)
    --DESTROY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c29201112.cost)
    e1:SetCondition(c29201112.con)
    e1:SetTarget(c29201112.tg)
    e1:SetOperation(c29201112.op)
    c:RegisterEffect(e1)
    --actlimit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetCode(EFFECT_CANNOT_ACTIVATE)
    e9:SetRange(LOCATION_PZONE)
    e9:SetTargetRange(0,1)
    e9:SetValue(c29201112.aclimit)
    e9:SetCondition(c29201112.actcon)
    c:RegisterEffect(e9)
end
function c29201112.splimit(e,c,sump,sumtype,sumpos,targetp)
    if c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1) then return false end
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201112.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201112.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201112.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201112,3))
end
function c29201112.repval(e,c)
    return c29201112.repfilter(c,e:GetHandlerPlayer())
end
function c29201112.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201112.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x53e1) and not c:IsDisabled()
end
function c29201112.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29201112.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201112.desfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c29201112.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29201112.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
    end
end
function c29201112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,29201112)==0 end
    Duel.RegisterFlagEffect(tp,29201112,RESET_PHASE+PHASE_END,0,1)
end
function c29201112.con(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsContains(e:GetHandler())
end
function c29201112.desfilter(c,e,tp)
    return c:IsDestructable()
end
function c29201112.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201112.desfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201112.desfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c29201112.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
        Duel.Damage(1-tp,1000,REASON_EFFECT)
    end
end
function c29201112.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c29201112.cfilter8(c,tp)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1))  and c:IsControler(tp)
end
function c29201112.actcon(e)
    local tp=e:GetHandlerPlayer()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a and c29201112.cfilter8(a,tp)) or (d and c29201112.cfilter8(d,tp))
end

