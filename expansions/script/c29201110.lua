--地耀团-人偶师 萨琳娜
function c29201110.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --spsummon
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29201110,0))
    e10:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetTarget(c29201110.sptg)
    e10:SetOperation(c29201110.spop)
    c:RegisterEffect(e10)
    --indes
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(29201110,2))
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e12:SetCode(EVENT_SPSUMMON_SUCCESS)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCondition(c29201110.indcon)
    e12:SetTarget(c29201110.indtg)
    e12:SetOperation(c29201110.indop)
    c:RegisterEffect(e12)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201110.reptg)
    ea:SetValue(c29201110.repval)
    ea:SetOperation(c29201110.repop)
    c:RegisterEffect(ea)
    --pierce
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x33e1))
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c29201110.damcon)
    e2:SetOperation(c29201110.damop)
    c:RegisterEffect(e2)
    --position
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201110,1))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetTarget(c29201110.postg)
    e3:SetOperation(c29201110.posop)
    c:RegisterEffect(e3)
end
function c29201110.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    local d=Duel.GetAttackTarget()
    if chk==0 then return d and d:IsControler(1-tp) end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function c29201110.posop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d:IsRelateToBattle() then
        Duel.ChangePosition(d,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201110.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x33e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201110.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201110.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201110,3))
end
function c29201110.repval(e,c)
    return c29201110.repfilter(c,e:GetHandlerPlayer())
end
function c29201110.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201110.cfilter(c,e,tp)
    return c:IsSetCard(0x33e1) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
        and (not e or c:IsRelateToEffect(e))
end
function c29201110.indcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201110.cfilter,1,nil,nil,tp)
end
function c29201110.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
end
function c29201110.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Filter(c29201110.cfilter,nil,e,tp)
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
function c29201110.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x33e1) and c:IsDestructable()
end
function c29201110.desfilter2(c,e)
    return c29201110.desfilter(c) and c:IsCanBeEffectTarget(e)
end
function c29201110.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201110.desfilter(chkc) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    if chk==0 then return ct<=3 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c29201110.desfilter,tp,LOCATION_ONFIELD,0,3,nil)
        and (ct<=0 or Duel.IsExistingTarget(c29201110.desfilter,tp,LOCATION_MZONE,0,ct,nil)) end
    local g=nil
    if ct>0 then
        local tg=Duel.GetMatchingGroup(c29201110.desfilter2,tp,LOCATION_ONFIELD,0,nil,e)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        g=tg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
        if ct<3 then
            tg:Sub(g)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local g2=tg:Select(tp,3-ct,3-ct,nil)
            g:Merge(g2)
        end
        Duel.SetTargetCard(g)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        g=Duel.SelectTarget(tp,c29201110.desfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201110.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
            Duel.SendtoGrave(c,REASON_RULE)
        end
    end
end
function c29201110.damcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return ep~=tp and tc:IsSetCard(0x33e1) and tc:GetBattleTarget()~=nil and tc:GetBattleTarget():IsDefensePos()
end
function c29201110.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end



