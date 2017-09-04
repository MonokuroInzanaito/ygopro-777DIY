--原罪碎片 暴食的岚
function c60158604.initial_effect(c)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60158604)
    e1:SetCondition(c60158604.condition)
    e1:SetTarget(c60158604.target)
    e1:SetOperation(c60158604.operation)
    c:RegisterEffect(e1)
	--get effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(c60158604.rmcon)
    e2:SetOperation(c60158604.negop1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetCondition(c60158604.rmcon)
    e3:SetOperation(c60158604.negop2)
    c:RegisterEffect(e3)
	--cannot remove
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60158601,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e4:SetCountLimit(1,6018604)
    e4:SetCost(c60158604.spcost)
    e4:SetTarget(c60158604.sptg)
    e4:SetOperation(c60158604.spop)
    c:RegisterEffect(e4)
end
function c60158604.condition(e,tp,eg,ep,ev,re,r,rp)
    return re and (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsRace(RACE_FIEND))
end
function c60158604.filter(c)
    return c:IsSetCard(0xab28) and c:IsAbleToHand()
end
function c60158604.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158604.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60158604.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60158604.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60158604.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetOriginalRace()==RACE_FIEND
end
function c60158604.negop1(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d~=nil then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x57a0000)
        d:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x57a0000)
        d:RegisterEffect(e2)
    end
end
function c60158604.negop2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x57a0000)
    a:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x57a0000)
    a:RegisterEffect(e2)
end
function c60158604.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c60158604.spfilter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158604.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158604.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c60158604.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158604.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end