--萌板娘 Pixiv
function c10990008.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10990008,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10990008)
    e1:SetCondition(c10990008.condition)
    e1:SetCost(c10990008.spcost)
    e1:SetTarget(c10990008.sptg)
    e1:SetOperation(c10990008.spop)
    c:RegisterEffect(e1)
end
function c10990008.dfilter(c,tp)
    return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c10990008.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c10990008.dfilter,1,nil,1-tp)
end
function c10990008.cfilter(c)
    return c:IsSetCard(0x232) and c:IsAbleToGraveAsCost()
end
function c10990008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10990008.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c10990008.cfilter,1,1,REASON_COST,e:GetHandler())
end
function c10990008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10990008.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    Duel.Draw(tp,2,REASON_EFFECT)
end