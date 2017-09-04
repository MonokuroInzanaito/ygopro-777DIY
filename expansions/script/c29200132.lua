--凋叶棕-御阿礼幻想艳戏谭
function c29200132.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200132,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29200132.destg)
    e1:SetOperation(c29200132.desop)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCountLimit(1,29200132)
    e2:SetTarget(c29200132.thtg)
    e2:SetOperation(c29200132.thop)
    c:RegisterEffect(e2)
    local e7=e2:Clone()
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e7)
    --cannot target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c29200132.indval)
    c:RegisterEffect(e5)
    --splimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c29200132.splimit8)
    c:RegisterEffect(e3)
end
function c29200132.splimit8(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x53e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29200132.thfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29200132.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200132.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29200132.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29200132.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c29200132.indval(e,re,tp)
    return tp~=e:GetHandlerPlayer()
end
function c29200132.desfilter1(c,tp,ec)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
        and Duel.IsExistingTarget(c29200132.desfilter2,tp,LOCATION_ONFIELD,0,1,c,ec)
end
function c29200132.desfilter2(c,ec)
    return c~=ec and c:IsFaceup() and c:IsSetCard(0x53e0) and c:IsDestructable()
end
function c29200132.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(c29200132.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,c29200132.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,c29200132.desfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c29200132.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
