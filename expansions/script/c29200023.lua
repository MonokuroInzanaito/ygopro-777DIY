--凋叶棕-绝对的一方通行
function c29200023.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c29200023.splimit8)
    c:RegisterEffect(e2)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200023,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,29200023)
    e1:SetTarget(c29200023.sptg1)
    e1:SetOperation(c29200023.spop1)
    c:RegisterEffect(e1)
    --to hand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(29200023,1))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(0x0081)
    e5:SetCode(29200000)
    e5:SetProperty(0x14000)
    e5:SetTarget(c29200023.tdtg)
    e5:SetOperation(c29200023.tdop)
    c:RegisterEffect(e5)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29200023,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c29200023.spcon)
    e4:SetCost(c29200023.spcost)
    e4:SetTarget(c29200023.sptg2)
    e4:SetOperation(c29200023.spop)
    c:RegisterEffect(e4)
end
function c29200023.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x53e0) and c:IsType(TYPE_MONSTER)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c29200023.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29200023.cfilter,1,nil,tp)
end
function c29200023.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(29200023)==0 end
    e:GetHandler():RegisterFlagEffect(29200023,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c29200023.filter(c,e,tp)
    return c:IsSetCard(0x53e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29200023.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29200023.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29200023.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29200023.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c29200023.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c29200023.tdop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,e:GetHandler())
    end
end
function c29200023.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c29200023.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(tp,70,71,72)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
            Duel.SendtoGrave(c,REASON_RULE)
        end
    end
    Duel.BreakEffect()
    Duel.MoveSequence(tc,1)
    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c29200023.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c29200023.splimit(e,c)
    return not c:IsSetCard(0x53e0)
end
function c29200023.splimit8(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x53e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end


