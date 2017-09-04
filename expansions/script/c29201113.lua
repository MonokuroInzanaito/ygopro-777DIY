--天辉团-疾风盗贼 翠丝特
function c29201113.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201113.reptg)
    ea:SetValue(c29201113.repval)
    ea:SetOperation(c29201113.repop)
    c:RegisterEffect(ea)
    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetTarget(c29201113.atktg1)
    e2:SetOperation(c29201113.atkop1)
    c:RegisterEffect(e2)
    --DESTROY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CHAIN_UNIQUE)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c29201113.cost)
    e1:SetCondition(c29201113.con)
    e1:SetTarget(c29201113.tg)
    e1:SetOperation(c29201113.op)
    c:RegisterEffect(e1)
    --pos
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetTarget(c29201113.postg)
    e3:SetOperation(c29201113.posop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --splimit
    local ec=Effect.CreateEffect(c)
    ec:SetType(EFFECT_TYPE_FIELD)
    ec:SetRange(LOCATION_PZONE)
    ec:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    ec:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    ec:SetTargetRange(1,0)
    ec:SetTarget(c29201113.splimit)
    c:RegisterEffect(ec)
end
function c29201113.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c29201113.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201113.splimit(e,c,sump,sumtype,sumpos,targetp)
    if c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1) then return false end
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201113.filter1(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) 
end
function c29201113.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c29201113.filter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201113.filter1,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c29201113.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c29201113.atkop1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(800)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c29201113.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201113.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201113.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201113,3))
end
function c29201113.repval(e,c)
    return c29201113.repfilter(c,e:GetHandlerPlayer())
end
function c29201113.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,29201113)==0 end
    Duel.RegisterFlagEffect(tp,29201113,RESET_PHASE+PHASE_END,0,1)
end
function c29201113.con(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsContains(e:GetHandler())
end
function c29201113.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0,nil)
end
function c29201113.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end