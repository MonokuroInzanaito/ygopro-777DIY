--红色骑士团·妖怪电话
function c60158822.initial_effect(c)
	--synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5b28),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
	--search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60158822,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60158822)
    e1:SetCondition(c60158822.thcon)
    e1:SetTarget(c60158822.thtg)
    e1:SetOperation(c60158822.thop)
    c:RegisterEffect(e1)
	--draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158822,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,6018822)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c60158822.cost)
    e2:SetTarget(c60158822.target)
    e2:SetOperation(c60158822.operation)
    c:RegisterEffect(e2)
	--sp
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158822,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c60158822.spcon)
    e3:SetTarget(c60158822.sptg)
    e3:SetOperation(c60158822.spop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60158822,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c60158822.con)
    e4:SetTarget(c60158822.sptg)
    e4:SetOperation(c60158822.spop)
    c:RegisterEffect(e4)
end
function c60158822.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60158822.thfilter(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60158822.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158822.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60158822.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60158822.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60158822.cfilter(c,tp)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c60158822.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158822.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60158822.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60158822.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c60158822.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c60158822.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c60158822.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO 
		and e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0) and re:GetHandler():IsSetCard(0x5b28)
end
function c60158822.spfilter(c,e,tp)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158822.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158822.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60158822.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158822.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
