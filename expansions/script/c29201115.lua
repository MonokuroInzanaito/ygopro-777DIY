--天辉团-霜雪圣姬 娜特莉
function c29201115.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
    e2:SetCost(c29201115.descost)
    e2:SetTarget(c29201115.destg)
    e2:SetOperation(c29201115.desop)
    c:RegisterEffect(e2)
    --special summon
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(29201115,1))
    e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e12:SetProperty(EFFECT_FLAG_DELAY)
    e12:SetCode(EVENT_BE_BATTLE_TARGET)
    e12:SetCountLimit(1,29201115)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTarget(c29201115.sptg)
    e12:SetOperation(c29201115.spop)
    c:RegisterEffect(e12)
    --destroy replace
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201115.reptg)
    ea:SetValue(c29201115.repval)
    ea:SetOperation(c29201115.repop)
    c:RegisterEffect(ea)
    --pos
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201115,1))
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetRange(LOCATION_PZONE)
    e7:SetCountLimit(1)
    e7:SetTarget(c29201115.postg)
    e7:SetOperation(c29201115.posop)
    c:RegisterEffect(e7)
end
function c29201115.spfilter(c,e,tp)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29201115.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201102.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29201115.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c29201115.filter(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) 
end
function c29201115.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c29201115.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201115.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,c29201115.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c29201115.posop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c29201115.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201115.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201115.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201115,3))
end
function c29201115.repval(e,c)
    return c29201115.repfilter(c,e:GetHandlerPlayer())
end
function c29201115.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201115.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,129201115)==0 end
    Duel.RegisterFlagEffect(tp,129201115,RESET_PHASE+PHASE_END,0,1)
end
function c29201115.desfilter1(c)
    return c:IsSetCard(0x53e1) and c:IsDestructable() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c29201115.desfilter2(c)
    return c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c29201115.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c29201115.desfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(c29201115.desfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,c29201115.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,c29201115.desfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c29201115.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end
