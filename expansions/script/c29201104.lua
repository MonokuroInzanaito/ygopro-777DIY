--地耀团-独眼的涡纹 莉斯
function c29201104.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --scale change
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(29201104,3))
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_PZONE)
    e9:SetCountLimit(1)
    e9:SetCondition(c29201104.sccon)
    e9:SetOperation(c29201104.scop)
    c:RegisterEffect(e9)
    --def
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetCondition(c29201104.cona)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201104,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c29201104.cona)
    e1:SetTarget(c29201104.postg)
    e1:SetOperation(c29201104.posop)
    c:RegisterEffect(e1)
    --negate
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(29201104,1))
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,29201104)
    e5:SetCode(EVENT_BE_BATTLE_TARGET)
    e5:SetCondition(c29201104.negcon)
    e5:SetOperation(c29201104.negop)
    c:RegisterEffect(e5)
    --send to grave
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201104,2))
    e10:SetCategory(CATEGORY_DAMAGE)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCode(EVENT_CHANGE_POS)
    e10:SetTarget(c29201104.target)
    e10:SetOperation(c29201104.operation)
    c:RegisterEffect(e10)
end
function c29201104.cona(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsAttackPos()
end
function c29201104.cond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
function c29201104.negcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsFaceup() and tc:IsSetCard(0x33e1) and tc:IsType(TYPE_MONSTER)
        and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and c29201104.cond(e,tp,eg,ep,ev,re,r,rp)
end
function c29201104.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.NegateAttack()~=0 then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201104.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(600)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c29201104.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c29201104.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x33e1)
end
function c29201104.filter2(c)
    return c:IsFaceup() 
end
function c29201104.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c29201104.filter1,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c29201104.filter2,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g1=Duel.SelectTarget(tp,c29201104.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g2=Duel.SelectTarget(tp,c29201104.filter2,tp,0,LOCATION_MZONE,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
end
function c29201104.pfilter(c,e)
    return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c29201104.posop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c29201104.pfilter,nil,e)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201104.sccon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
    local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
    return tc and tc:IsSetCard(0x33e1)
end
function c29201104.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LSCALE)
    e1:SetValue(9)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c29201104.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function c29201104.splimit(e,c)
    return not c:IsSetCard(0x33e1)
end
