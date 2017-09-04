--再临的祈愿
function c60158909.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60158909)
    e1:SetCondition(c60158909.condition)
    e1:SetTarget(c60158909.target)
    e1:SetOperation(c60158909.activate)
    c:RegisterEffect(e1)
	--salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,6018909+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(c60158909.spcon)
    e2:SetCost(c60158909.spcost)
    e2:SetTarget(c60158909.sptg)
    e2:SetOperation(c60158909.spop)
    c:RegisterEffect(e2)
end
function c60158909.cfilter(c)
    return not (c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT))
end
function c60158909.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c60158909.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c60158909.filter(c)
    return c:IsRace(RACE_DRAGON) and c:GetLevel()==8 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c60158909.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,e:GetHandler(),TYPE_MONSTER)
        and Duel.IsExistingMatchingCard(c60158909.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60158909.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158909,0))
    local ag=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
    if ag:GetCount()>0 then
        Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
        Duel.ConfirmCards(tp,ag)
        Duel.ShuffleHand(tp)
        Duel.ShuffleHand(1-tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c60158909.filter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.BreakEffect()
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c60158909.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<Duel.GetLP(1-tp) 
end
function c60158909.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,ATTRIBUTE_LIGHT) end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
    local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,ATTRIBUTE_LIGHT)
    Duel.Release(g,REASON_COST)
end
function c60158909.spfilter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c60158909.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158909.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c60158909.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158909.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c60158909.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c60158909.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_LIGHT)
end