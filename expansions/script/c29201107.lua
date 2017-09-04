--地耀团-黑魔女 菲丽丝
function c29201107.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201107.reptg)
    ea:SetValue(c29201107.repval)
    ea:SetOperation(c29201107.repop)
    c:RegisterEffect(ea)
    --indes1
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c29201107.cona)
    e1:SetTarget(c29201107.targeta)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(c29201107.cond)
    e2:SetTarget(c29201107.targetd)
    e2:SetValue(aux.TRUE)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201107,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(c29201107.sptg)
    e4:SetOperation(c29201107.spop)
    c:RegisterEffect(e4)
    --draw
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(29201107,0))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c29201107.drcost)
    e5:SetTarget(c29201107.drtg)
    e5:SetOperation(c29201107.drop)
    c:RegisterEffect(e5)
end
function c29201107.costfilter(c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsDiscardable()
end
function c29201107.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201107.costfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c29201107.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c29201107.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29201107.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c29201107.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x33e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201107.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201107.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201107,3))
end
function c29201107.repval(e,c)
    return c29201107.repfilter(c,e:GetHandlerPlayer())
end
function c29201107.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201107.cona(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsAttackPos()
end
function c29201107.cond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
function c29201107.targeta(e,c)
    return c:IsSetCard(0x33e1)
end
function c29201107.targetd(e,c)
    return c:IsSetCard(0x33e1)
end
function c29201107.spfilter(c,e,tp)
    return c:IsSetCard(0x33e1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201107.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29201107.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201107.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
        local at=Duel.GetAttacker()
        if at and not at:IsImmuneToEffect(e) and Duel.ChangeAttackTarget(tc) then
            Duel.BreakEffect()
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_SET_ATTACK_FINAL)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            e3:SetValue(math.ceil(at:GetAttack()/2))
            at:RegisterEffect(e3)
        end
    end
end

