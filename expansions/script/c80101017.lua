--刀魂-物吉贞宗
function c80101017.initial_effect(c)
    --special summon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_DECK)
    e1:SetCountLimit(3,81101101)
    e1:SetCondition(c80101017.spcon)
    e1:SetOperation(c80101017.spop)
    --set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(c80101017.sumop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80101017,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,80101017)
    e4:SetCondition(c80101017.setcon)
    e4:SetCost(c80101017.setcost)
    e4:SetTarget(c80101017.settg)
    e4:SetOperation(c80101017.setop)
    c:RegisterEffect(e4)
    --search
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80101017,1))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e0:SetProperty(EFFECT_FLAG_DELAY)
    e0:SetCode(EVENT_BE_MATERIAL)
    e0:SetCountLimit(1,80101417)
    e0:SetCondition(c80101017.condition)
    e0:SetTarget(c80101017.target)
    e0:SetOperation(c80101017.operation)
    c:RegisterEffect(e0)
end
function c80101017.spfilter1(c)
    return c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,80101018)
end
function c80101017.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c80101017.spfilter1,1,nil)
end
function c80101017.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c80101017.spfilter1,1,1,nil)
    Duel.Release(g,REASON_COST)
    Duel.ShuffleDeck(tp)
end
function c80101017.sumop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(80101017,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80101017.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(80101017)>0
end
function c80101017.cfilter(c,e,tp)
    local lv=c:GetLevel()
    return lv>0 and c:IsSetCard(0x5400)
        and Duel.IsExistingMatchingCard(c80101017.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c80101017.filter(c,e,tp,lv)
    return c:IsSetCard(0x5400) and c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101017.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c80101017.cfilter,1,nil,e,tp) end
    local g=Duel.SelectReleaseGroup(tp,c80101017.cfilter,1,1,nil,e,tp)
    e:SetLabel(g:GetFirst():GetLevel())
    Duel.Release(g,REASON_COST)
end
function c80101017.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80101017.setop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local lv=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80101017.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c80101017.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
		and c:GetReasonCard():IsSetCard(0x5400)
end
function c80101017.filter0(c,e,tp)
    return c:IsSetCard(0x5400) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101017.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c80101017.filter0,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local t={}
    local i=1
    for i=1,12 do t[i]=i end
    Duel.Hint(HINT_SELECTMSG,tp,567)
    local lv=Duel.AnnounceNumber(tp,table.unpack(t))
    e:SetLabel(lv)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c80101017.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80101017.filter0,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if g:GetCount()>0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(e:GetLabel())
        e3:SetReset(RESET_EVENT+0x1ff0000)
        tc:RegisterEffect(e3)
    end
    Duel.SpecialSummonComplete()
end


