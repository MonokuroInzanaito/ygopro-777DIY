--镜世录 人鱼姬
function c29201042.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --spsummon
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201042,4))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_PZONE)
    e7:SetCost(c29201042.spcost)
    e7:SetTarget(c29201042.sptg)
    e7:SetOperation(c29201042.spop)
    c:RegisterEffect(e7)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201042,1))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,29201042)
    e1:SetTarget(c29201042.thtg)
    e1:SetOperation(c29201042.thop)
    c:RegisterEffect(e1)
    --disable spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201042,0))
    e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_SPSUMMON)
    e3:SetCountLimit(1)
    e3:SetCondition(c29201042.condition)
    e3:SetTarget(c29201042.target)
    e3:SetOperation(c29201042.operation)
    c:RegisterEffect(e3)
    --tograve
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29201042,2))
    e8:SetCategory(CATEGORY_TOGRAVE)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e8:SetTarget(c29201042.tgtg)
    e8:SetOperation(c29201042.tgop)
    c:RegisterEffect(e8)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c29201042.pencon)
    e4:SetTarget(c29201042.pentg)
    e4:SetOperation(c29201042.penop)
    c:RegisterEffect(e4)
end
function c29201042.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c29201042.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201042.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c29201042.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201042.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c29201042.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=ep and Duel.GetCurrentChain()==0
end
function c29201042.filter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) 
end
function c29201042.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201042.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c29201042.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201042.filter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c29201042.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201042.desfilter(c)
    return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x63e0) and c:IsDestructable()
end
function c29201042.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c29201042.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201042.desfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201042.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29201042.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29201042.tgfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c29201042.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201042.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c29201042.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201042.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c29201042.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c29201042.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201042.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201042.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c29201042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201042.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
