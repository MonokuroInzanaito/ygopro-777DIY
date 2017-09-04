--幻想物语 通往奇迹的兔子洞
function c80100006.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,80100006+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c80100006.rlcost)
    e1:SetTarget(c80100006.target)
    e1:SetOperation(c80100006.activate)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80100006,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,80110006)
    e2:SetCost(c80100006.thcost)
    e2:SetTarget(c80100006.thtg)
    e2:SetOperation(c80100006.thop)
    c:RegisterEffect(e2)
end
function c80100006.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c80100006.filter(c,e,tp)
    return c:IsCode(80100001) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80100006.thfilter(c)
    return c:IsSetCard(0x3400) and c:IsAbleToHand()
end
function c80100006.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c80100006.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    local b2=Duel.IsExistingMatchingCard(c80100006.thfilter,tp,LOCATION_DECK,0,1,nil)
    if chk==0 then return b1 or b2 end
    local op=0
    if b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(80100006,0),aux.Stringid(80100006,1))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(80100006,0))
    else 
	    op=Duel.SelectOption(tp,aux.Stringid(80100006,1))+1 
	end
    e:SetLabel(op)
    if op==0 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    else
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    end
end
function c80100006.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        --Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SelectOption(1-tp,aux.Stringid(80100006,0))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c80100006.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if g:GetCount()>0 then
            Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
            tc:CompleteProcedure()
        end
    else
        --Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SelectOption(1-tp,aux.Stringid(80100006,1))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c80100006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function c80100006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0x3400) end
    local sg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0x3400)
    Duel.Release(sg,REASON_COST)
end
function c80100006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c80100006.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end

