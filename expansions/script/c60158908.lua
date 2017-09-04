--染血的花嫁 赤羽乐
function c60158908.initial_effect(c)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158908,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,60158908)
    e2:SetCondition(c60158908.setcon)
    e2:SetCost(c60158908.cost)
    e2:SetTarget(c60158908.settg2)
    e2:SetOperation(c60158908.setop)
    c:RegisterEffect(e2)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158908,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,60158908)
    e2:SetTarget(c60158908.sptg)
    e2:SetOperation(c60158908.spop)
    c:RegisterEffect(e2)
end

function c60158908.cfilter(c,tp,rp)
    return rp~=tp and c:IsPreviousLocation(LOCATION_SZONE) 
		and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c60158908.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60158908.cfilter,1,nil,tp,rp)
end
function c60158908.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c60158908.thfilter1(c,tp)
	local lv=c:GetLevel()
	local zz=c:GetRace()
	local att=c:GetAttribute()
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() 
		and Duel.IsExistingMatchingCard(c60158908.thfilter2,tp,LOCATION_DECK,0,1,c,lv,zz,att)
end
function c60158908.thfilter2(c,lv,zz,att)
    return c:GetLevel()==lv and c:GetRace()==zz and c:GetAttribute()~=att
		and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c60158908.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158908.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60158908.setop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60158908.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local lv=tc:GetLevel()
	local zz=tc:GetRace()
	local att=tc:GetAttribute()
	local g2=Duel.SelectMatchingCard(tp,c60158908.thfilter1,tp,LOCATION_DECK,0,1,1,tc,lv,zz,att)
	local tc2=g2:GetFirst()
	g:AddCard(tc2)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60158908.spfilter(c)
    return ((c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_MZONE)) 
		or (c:IsFaceup() and (c:GetSequence()==6 or c:GetSequence()==7))) 
		and c:IsDestructable()
end
function c60158908.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60158908.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c60158908.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60158908.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end