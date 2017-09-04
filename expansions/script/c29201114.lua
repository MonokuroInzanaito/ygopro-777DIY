--天辉团-魔操线使 蕾娜塔
function c29201114.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --scale change
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(29201114,3))
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_PZONE)
    e9:SetCountLimit(1)
    e9:SetCondition(c29201114.sccon)
    e9:SetOperation(c29201114.scop)
    c:RegisterEffect(e9)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,29201114)
    e1:SetCondition(c29201114.spcon)
    e1:SetTarget(c29201114.sptg)
    e1:SetOperation(c29201114.spop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201114,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetCountLimit(1,29201114)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c29201114.sptg)
    e2:SetOperation(c29201114.spop)
    c:RegisterEffect(e2)
end
function c29201114.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x53e1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201114.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29201114.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201114.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local a=Duel.GetAttacker()
        local ag=a:GetAttackableTarget()
        if a:IsAttackable() and not a:IsImmuneToEffect(e) and ag:IsContains(tc) then
            Duel.BreakEffect()
            Duel.ChangeAttackTarget(tc)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(math.ceil(a:GetAttack()/2))
            a:RegisterEffect(e1)
        end
    end
end
function c29201114.spcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsContains(e:GetHandler())
end
function c29201114.spfilter(c,e,tp)
    return c:IsSetCard(0x53e1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29201114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201114.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29201114.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201114.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c29201114.sccon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
    local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
    return tc and tc:IsSetCard(0x53e1)
end
function c29201114.scop(e,tp,eg,ep,ev,re,r,rp)
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
    e3:SetTarget(c29201114.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function c29201114.splimit(e,c)
    return not c:IsSetCard(0x53e1)
end
