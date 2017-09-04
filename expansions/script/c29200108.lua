--凋叶棕-Un-Demystified Fantasy
function c29200108.initial_effect(c)
    --pierce
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c29200108.con)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x53e0))
    c:RegisterEffect(e1)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,29200108)
    e3:SetCondition(c29200108.thcon)
    e3:SetTarget(c29200108.thtg)
    e3:SetOperation(c29200108.thop)
    c:RegisterEffect(e3)
    --splimit
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    ea:SetRange(LOCATION_GRAVE)
    ea:SetTargetRange(1,0)
    ea:SetCondition(c29200108.con)
    ea:SetTarget(c29200108.splimit)
    c:RegisterEffect(ea)
    local eb=ea:Clone()
    eb:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(eb)
end
c29200108.dyz_utai_list=true
function c29200108.splimit(e,c)
    return not c:IsSetCard(0x53e0)
end
function c29200108.con(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
    return e:GetHandler()==tc
end
function c29200108.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_BATTLE)
        or (rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
end
function c29200108.thfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_MONSTER) and not c:IsCode(29200108) and c:IsAbleToHand()
end
function c29200108.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200108.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29200108.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29200108.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

