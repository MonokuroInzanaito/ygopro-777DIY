--
function c29200021.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(Card.IsRace,RACE_PSYCHO),1)
    c:EnableReviveLimit()
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c29200021.destg)
    e2:SetValue(1)
    e2:SetOperation(c29200021.desop)
    c:RegisterEffect(e2)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c29200021.efilter)
    c:RegisterEffect(e4)
    --counter
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c29200021.condition1)
    e5:SetOperation(c29200021.handes)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e7)
end
function c29200021.efilter(e,re,rp)
    if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    return not g:IsContains(e:GetHandler())
end
function c29200021.cfilter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()~=tp
end
function c29200021.condition1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29200021.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler()) 
end
function c29200021.filter1(c)
    return not c:IsPublic()
end
function c29200021.filter2(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()~=tp and c:IsRelateToEffect(e)
end
function c29200021.handes(e,tp,eg,ep,ev,re,r,rp)
    local cg=Duel.GetMatchingGroup(c29200021.filter1,tp,0,LOCATION_HAND,nil)
    if cg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(29200021,0)) then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
            local sg=cg:Select(1-tp,1,1,nil)
            --Duel.ConfirmCards(tp,sg)
            local tc=sg:GetFirst()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_PUBLIC)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            Duel.ShuffleHand(1-tp)
            Duel.BreakEffect()
    else 
            local tc=eg:GetFirst()
            while tc do
                if tc:IsFaceup() and tc:GetSummonPlayer()~=tp then
                    Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
                end
                tc=eg:GetNext()
            end
    end
end
function c29200021.rfilter(c)
    return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function c29200021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local tc=eg:GetFirst()
        return tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) and tc:IsRace(RACE_PSYCHO) 
		   and tc:IsReason(REASON_BATTLE+REASON_EFFECT) and Duel.IsExistingMatchingCard(c29200021.rfilter,tp,LOCATION_GRAVE,0,1,nil)
    end
    return Duel.SelectYesNo(tp,aux.Stringid(29200021,3))
end
function c29200021.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c29200021.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
