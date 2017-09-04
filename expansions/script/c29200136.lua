--凋叶棕-在那门扉的另一侧
function c29200136.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200136,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29200136.destg)
    e1:SetOperation(c29200136.desop)
    c:RegisterEffect(e1)
    --splimit
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_FIELD)
    ea:SetRange(LOCATION_PZONE)
    ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    ea:SetTargetRange(1,0)
    ea:SetTarget(c29200136.splimit8)
    c:RegisterEffect(ea)
    --special summon
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_SPSUMMON_PROC)
    e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e8:SetRange(LOCATION_HAND)
    e8:SetCondition(c29200136.spcon)
    c:RegisterEffect(e8)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetTarget(c29200136.destg1)
    e3:SetOperation(c29200136.desop1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetCountLimit(1,29200136)
    e6:SetCondition(c29200136.spcon1)
    e6:SetTarget(c29200136.sptg)
    e6:SetOperation(c29200136.spop)
    c:RegisterEffect(e6)
end
function c29200136.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c29200136.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c29200136.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29200136.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29200136.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29200136.desop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c29200136.cfilter(c)
    return c:IsFacedown() or c:IsCode(29200136) or not c:IsSetCard(0x53e0)
end
function c29200136.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
        and not Duel.IsExistingMatchingCard(c29200136.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c29200136.splimit8(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x53e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29200136.desfilter1(c,tp,ec)
    return c:IsType(TYPE_MONSTER) and c:IsDestructable()
        and Duel.IsExistingTarget(c29200136.desfilter2,tp,LOCATION_ONFIELD,0,1,c,ec)
end
function c29200136.desfilter2(c,ec)
    return c~=ec and c:IsFaceup() and c:IsSetCard(0x53e0) and c:IsDestructable()
end
function c29200136.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(c29200136.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,c29200136.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,c29200136.desfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c29200136.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function c29200136.spcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c29200136.spfilter(c,e,tp)
    return c:IsSetCard(0x53e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29200136.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29200136.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c29200136.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c29200136.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c29200136.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end


