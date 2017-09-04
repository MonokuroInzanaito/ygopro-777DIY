--天辉团-胜利之光 西格莉德
function c29201120.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201120,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c29201120.sptg)
    e1:SetOperation(c29201120.spop)
    c:RegisterEffect(e1)
    --indes
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(29201120,2))
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e12:SetCode(EVENT_SPSUMMON_SUCCESS)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCondition(c29201120.indcon)
    e12:SetTarget(c29201120.indtg)
    e12:SetOperation(c29201120.indop)
    c:RegisterEffect(e12)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201120.reptg)
    ea:SetValue(c29201120.repval)
    ea:SetOperation(c29201120.repop)
    c:RegisterEffect(ea)
    --[[cannot be target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(c29201120.atlimit)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetTargetRange(0,0xff)
    e5:SetValue(c29201120.tglimit)
    c:RegisterEffect(e5)]]
    --immune effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCondition(c29201120.immcon)
    e4:SetTarget(c29201120.etarget)
    e4:SetValue(c29201120.efilter)
    c:RegisterEffect(e4)
	--
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29201120,4))
    e8:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_DAMAGE_STEP_END)
    e8:SetCondition(c29201120.effcon)
    e8:SetTarget(c29201120.attar)
    e8:SetOperation(c29201120.atop)
    c:RegisterEffect(e8)
end
function c29201120.immcon(e)
    local tp=e:GetHandlerPlayer()
    local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    return (c1 and c1:IsSetCard(0x53e1)) or (c2 and c2:IsSetCard(0x53e1))
end
function c29201120.etarget(e,c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER)
end
function c29201120.efilter(e,re)
    return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c29201120.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c29201120.attar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c29201120.atop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(1-tp,1)
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        local tc=sg:GetFirst()
        if tc:IsType(TYPE_MONSTER) then
            Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
        end
    end
end
function c29201120.filter(c,lv)
    return c:IsFaceup() and c:IsSetCard(0x53e1) and c:GetLevel()>lv
end
function c29201120.atlimit(e,c)
    return c:IsFaceup() and c:IsSetCard(0x53e1) and Duel.IsExistingMatchingCard(c29201120.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel())
end
function c29201120.tglimit(e,re,c)
    return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x53e1) 
        and Duel.IsExistingMatchingCard(c29201120.filter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel())
end
function c29201120.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201120.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201120.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201120,3))
end
function c29201120.repval(e,c)
    return c29201120.repfilter(c,e:GetHandlerPlayer())
end
function c29201120.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201120.cfilter(c,e,tp)
    return c:IsSetCard(0x53e1) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
        and (not e or c:IsRelateToEffect(e))
end
function c29201120.indcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29201120.cfilter,1,nil,nil,tp)
end
function c29201120.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
end
function c29201120.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Filter(c29201120.cfilter,nil,e,tp)
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
function c29201120.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x53e1) and c:IsDestructable()
end
function c29201120.desfilter2(c,e)
    return c29201120.desfilter(c) and c:IsCanBeEffectTarget(e)
end
function c29201120.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201120.desfilter(chkc) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    if chk==0 then return ct<=3 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c29201120.desfilter,tp,LOCATION_ONFIELD,0,3,nil)
        and (ct<=0 or Duel.IsExistingTarget(c29201120.desfilter,tp,LOCATION_MZONE,0,ct,nil)) end
    local g=nil
    if ct>0 then
        local tg=Duel.GetMatchingGroup(c29201120.desfilter2,tp,LOCATION_ONFIELD,0,nil,e)
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
        g=Duel.SelectTarget(tp,c29201120.desfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201120.spop(e,tp,eg,ep,ev,re,r,rp)
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



