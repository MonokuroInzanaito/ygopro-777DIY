--刀魂-萤丸
function c80101014.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,c80101014.synfilter,aux.NonTuner(c80101014.synfilter2),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(80101014,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c80101014.target)
    e1:SetOperation(c80101014.operation)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101014,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(c80101014.thcon)
    e2:SetTarget(c80101014.destg)
    e2:SetOperation(c80101014.desop)
    c:RegisterEffect(e2)
    --to grave
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(EVENT_TO_GRAVE)
    e0:SetOperation(c80101014.tgop)
    c:RegisterEffect(e0)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1,80101014)
    e5:SetCondition(c80101014.spcon)
    e5:SetTarget(c80101014.sptg)
    e5:SetOperation(c80101014.spop)
    c:RegisterEffect(e5)
end
function c80101014.tgop(e,tp,eg,ep,ev,re,r,rp)
    if bit.band(r,REASON_RETURN+REASON_ADJUST)~=0 then return end
    e:GetHandler():RegisterFlagEffect(80101014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80101014.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(80101014)~=0
end
function c80101014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80101014.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        Duel.Damage(tp,1000,REASON_EFFECT)
    end
end
function c80101014.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c80101014.filter1(c,atk)
    return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c80101014.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local atk=e:GetHandler():GetBattleTarget():GetAttack()
    if chk==0 then return Duel.IsExistingMatchingCard(c80101014.filter1,tp,0,LOCATION_MZONE,1,nil,atk) end
    local g=Duel.GetMatchingGroup(c80101014.filter1,tp,0,LOCATION_MZONE,nil,atk)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80101014.desop(e,tp,eg,ep,ev,re,r,rp)
    local atk=e:GetHandler():GetBattleTarget():GetAttack()
    local g=Duel.GetMatchingGroup(c80101014.filter1,tp,0,LOCATION_MZONE,nil,atk)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CHANGE_DAMAGE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        e1:SetValue(0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end
function c80101014.synfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_ZOMBIE)
end
function c80101014.synfilter2(c)
    return c:IsRace(RACE_ZOMBIE)
end
function c80101014.filter(c,e,tp,ec)
    return c:IsSetCard(0x6400)  and c:IsType(TYPE_EQUIP) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c80101014.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80101014.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetMatchingGroup(c80101014.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g1=g:Select(tp,1,1,nil)
    g:RemoveCard(g1:GetFirst())
    if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80101014,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
    end
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c80101014.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if ft<g:GetCount() then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,true,true)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
end

