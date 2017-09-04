--刀魂-五虎退
function c80101004.initial_effect(c)
    --special summon proc
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetRange(LOCATION_DECK)
    e0:SetCountLimit(3,81101101)
    e0:SetCondition(c80101004.spcon1)
    e0:SetOperation(c80101004.spop1)
    c:RegisterEffect(e0)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c80101004.effcon)
    e1:SetOperation(c80101004.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101004,0))
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,80101004)
    e2:SetCondition(c80101004.tgcon)
    e2:SetTarget(c80101004.sptg)
    e2:SetOperation(c80101004.spop)
    c:RegisterEffect(e2)
    --to grave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80101004,1))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,80101004)
    e3:SetTarget(c80101004.tgtg)
    e3:SetOperation(c80101004.tgop)
    c:RegisterEffect(e3)
end
function c80101004.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE+LOCATION_DECK)
end
function c80101004.sumop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(80101004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80101004.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(80101004)>0
end
function c80101004.tgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EQUIP) 
end
function c80101004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) 
	    and Duel.IsExistingMatchingCard(c80101004.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c80101004.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local tg=Duel.SelectMatchingCard(tp,c80101004.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    local tc=tg:GetFirst()
    if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
function c80101004.spfilter1(c)
    return c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,80101009)
end
function c80101004.spcon1(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c80101004.spfilter1,1,nil)
end
function c80101004.spop1(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c80101004.spfilter1,1,1,nil)
    Duel.Release(g,REASON_COST)
    Duel.ShuffleDeck(tp)
end
function c80101004.tgfilter1(c)
    return c:IsSetCard(0x6400) and c:IsAbleToGrave()
end
function c80101004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101004.tgfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c80101004.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c80101004.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

