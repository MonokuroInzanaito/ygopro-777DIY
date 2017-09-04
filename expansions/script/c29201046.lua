--镜世录 莲华世界
function c29201046.initial_effect(c)
    --return to Spell
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201046,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e4:SetCountLimit(1,29201046)
    e4:SetCost(c29201046.cost)
    e4:SetTarget(c29201046.target)
    e4:SetOperation(c29201046.op)
    c:RegisterEffect(e4)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201046,1))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,29201046)
    e3:SetTarget(c29201046.tdtg)
    e3:SetOperation(c29201046.tdop)
    c:RegisterEffect(e3)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201046.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_ONFIELD)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201046.splimit)
    c:RegisterEffect(e13)
end
function c29201046.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201046.thfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29201046.filter1(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c29201046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c29201046.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201046.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c29201046.thfilter,tp,LOCATION_DECK,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c29201046.filter2(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) 
end
function c29201046.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c29201046.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
        local g1=Duel.GetMatchingGroup(c29201046.filter2,tp,LOCATION_DECK,0,nil)
        if g1:GetCount()>=3 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
            local sg1=g1:Select(tp,3,3,nil)
            Duel.ConfirmCards(1-tp,sg1)
            Duel.ShuffleDeck(tp)
            local cg=sg1:Select(1-tp,1,1,nil)
            local tc=cg:GetFirst()
            if tc:IsAbleToHand() then
                Duel.SendtoHand(tc,nil,REASON_EFFECT)
                sg1:RemoveCard(tc)
            end
            Duel.SendtoGrave(sg1,REASON_EFFECT)
        end
    end
end
function c29201046.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201046.filter(c,e,tp)
    return c:IsSetCard(0x63e0) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201046.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
        local g=Duel.GetMatchingGroup(c29201046.filter,tp,LOCATION_SZONE,0,e:GetHandler(),e,tp)
        if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 and Duel.SelectYesNo(tp,aux.Stringid(29201046,3)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c29201046.filter,tp,LOCATION_SZONE,0,1,1,e:GetHandler(),e,tp)
     	    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        end
    end
end
