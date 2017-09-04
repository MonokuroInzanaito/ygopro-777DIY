--凋叶棕-光芒
function c29200127.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c29200127.splimit8)
    c:RegisterEffect(e3)
    --deck check
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200127,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29200127.target)
    e1:SetOperation(c29200127.operation1)
    c:RegisterEffect(e1)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29200127,2))
    e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(29200000)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c29200127.tdtg)
	e4:SetOperation(c29200127.tdop)
	c:RegisterEffect(e4)
    --[[counter
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29200127,3))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_CUSTOM+29200001)
    e7:SetRange(LOCATION_HAND)
    e7:SetTarget(c29200127.sptg)
    e7:SetOperation(c29200127.spop)
    c:RegisterEffect(e7)]]
    --tohand
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(29200127,1))
    e8:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_PHASE+PHASE_END)
    e8:SetRange(LOCATION_PZONE)
    e8:SetCondition(c29200127.thcon)
    e8:SetTarget(c29200127.thtg)
    e8:SetOperation(c29200127.thop)
    c:RegisterEffect(e8)
    --special summon
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(29200127,3))
    e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e10:SetCountLimit(1,29200127)
    e10:SetCost(c29200127.spcost)
    e10:SetTarget(c29200127.sptg)
    e10:SetOperation(c29200127.spop)
    c:RegisterEffect(e10)
end
function c29200127.splimit8(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x53e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29200127.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200127.operation1(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x53e0)) then
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
        Duel.Draw(tp,1,REASON_EFFECT)
    else
        Duel.MoveSequence(tc,1)
        Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    end
end
function c29200127.operation2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x53e0)) then
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
        Duel.Draw(tp,1,REASON_EFFECT)
    else
        Duel.MoveSequence(tc,1)
        --Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
    end
end
function c29200127.thfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c29200127.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29200127.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29200127.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c29200127.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29200127.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
--[[
function c29200127.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29200127.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
]]
c29200127.list={[29200161]=29200118,
				[29200162]=29200127,
				[29200163]=29200131,
				[29200164]=29200023,
				[29200165]=29200134,
                [29200167]=29200126,
                [29200168]=29200109}
function c29200127.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c29200127.filter1(c,tp)
    local code=c:GetCode()
    local tcode=c29200127.list[code]
    return tcode and Duel.IsExistingMatchingCard(c29200127.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,tcode,c)
end
function c29200127.filter2(c,tcode)
    if c:IsForbidden() or not c:IsAbleToHand() then return false end
    return c:IsCode(tcode) 
end
function c29200127.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c29200127.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c29200127.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local cg=Duel.SelectMatchingCard(tp,c29200127.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    if cg:GetCount()==0 then return end
    Duel.ConfirmCards(1-tp,cg)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local code=cg:GetFirst():GetCode()
    local tcode=c29200127.list[code]
    local g=Duel.SelectMatchingCard(tp,c29200127.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,tcode,cg:GetFirst())
    local tc=g:GetFirst()
    if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,tc)
    end
end
function c29200127.spfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c29200127.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29200127.spfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c29200127.spfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c29200127.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29200127.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end





