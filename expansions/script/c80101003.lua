--刀魂-今剑
function c80101003.initial_effect(c)
    --special summon proc
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetRange(LOCATION_DECK)
    e0:SetCountLimit(3,81101101)
    e0:SetCondition(c80101003.spcon)
    e0:SetOperation(c80101003.spop)
    c:RegisterEffect(e0)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(c80101003.destg)
    e4:SetOperation(c80101003.desop)
    c:RegisterEffect(e4)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c80101003.thcon1)
    e2:SetOperation(c80101003.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80101003,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,80101003)
    e3:SetCondition(c80101003.thcon)
    e3:SetTarget(c80101003.target)
    e3:SetOperation(c80101003.operation)
    c:RegisterEffect(e3)
end
function c80101003.thcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_RELEASE)
end
function c80101003.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(80101003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80101003.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(80101003)>0 
end
function c80101003.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80101003.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
        Duel.SetLP(tp,Duel.GetLP(tp)-800)
    end
end
function c80101003.spfilter1(c)
    return c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,80101008)
end
function c80101003.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c80101003.spfilter1,1,nil)
end
function c80101003.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c80101003.spfilter1,1,1,nil)
    Duel.Release(g,REASON_COST)
    Duel.ShuffleDeck(tp)
end
function c80101003.tgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EQUIP) 
		and Duel.IsExistingMatchingCard(c80101003.cfilter,c:GetControler(),LOCATION_DECK,0,1,nil,c)
end
function c80101003.cfilter(c,tc)
    return c:IsSetCard(0x6400) and not c:IsCode(tc:GetCode()) and c:IsAbleToGrave()
end
function c80101003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c80101003.tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80101003.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c80101003.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c80101003.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c80101003.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
    if g:GetCount()>0 then
        local gc=g:GetFirst()
        if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_CODE)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e1:SetValue(gc:GetCode())
            tc:RegisterEffect(e1)
        end
    end
end

