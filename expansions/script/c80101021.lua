--刀术-雪
function c80101021.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(80101021,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,80101021+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c80101021.target)
    e1:SetOperation(c80101021.activate)
    c:RegisterEffect(e1)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80101021,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,80101021)
    e3:SetCost(c80101021.thcost)
    e3:SetTarget(c80101021.thtg)
    e3:SetOperation(c80101021.thop)
    c:RegisterEffect(e3)
    if c80101021.global_effect==nil then
        c80101021.global_effect=true
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e1:SetCode(EVENT_RELEASE)
        e1:SetOperation(c80101021.addcount)
        Duel.RegisterEffect(e1,0)
    end
end
function c80101021.addcount(e,tp,eg,ep,ev,re,r,rp)
    local c=eg:GetFirst()
    while c~=nil do
        local pl=c:GetPreviousLocation()
        if pl==LOCATION_MZONE and c:IsSetCard(0x5400) and c:IsType(TYPE_MONSTER) then
            local p=c:GetReasonPlayer()
            Duel.RegisterFlagEffect(p,80101021,RESET_PHASE+PHASE_END,0,1)
        end
        c=eg:GetNext()
    end
end
function c80101021.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function c80101021.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c80101021.effectcon)
    e1:SetOperation(c80101021.effectop)
    Duel.RegisterEffect(e1,tp)
end
function c80101021.effectcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,80101021)>0
end
function c80101021.filter0(c)
    return c:IsSetCard(0x9400) and not c:GetCode()~=80101021 and c:IsAbleToHand() 
end
function c80101021.effectop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,80101021)
    local ct=Duel.GetFlagEffect(tp,80101021)
    if ct==1 then
        Duel.Draw(tp,1,REASON_EFFECT)
    elseif ct==2 then
        local g=Duel.GetMatchingGroup(c80101021.filter0,tp,LOCATION_DECK,0,nil)
        if g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local tg=g:Select(tp,1,1,nil)
            Duel.SendtoHand(tg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tg)
        end
    else
        local g=Duel.GetMatchingGroup(c80101021.filter0,tp,LOCATION_DECK,0,nil)
        if g:GetCount()>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local tg=g:Select(tp,2,2,nil)
            Duel.SendtoHand(tg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tg)
        end
    end
end
function c80101021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
c80101021.list={
[80101006]=80101001,
[80101007]=80101002,
[80101008]=80101003,
[80101009]=80101004,
[80101010]=80101005,
[80101018]=80101017
}
function c80101021.filter1(c,e,tp)
    local code=c:GetCode()
    local tcode=c80101021.list[code] 
	return tcode and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c80101021.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tcode,e,tp)
end
function c80101021.filter2(c,tcode,e,tp)
    return c:IsCode(tcode) and c:IsAbleToHand() and not c:IsForbidden()
end
function c80101021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        if e:GetLabel()~=1 then return false end
        e:SetLabel(0)
        return e:GetHandler():IsDiscardable() 
		    and Duel.IsExistingMatchingCard(c80101021.filter1,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c80101021.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    e:SetLabel(tc:GetCode())
    Duel.ConfirmCards(1-tp,g)
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
    Duel.ShuffleHand(tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80101021.thop(e,tp,eg,ep,ev,re,r,rp)
    local code=e:GetLabel()
    local tcode=c80101021.list[code]
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101021.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tcode,e,tp)
    if g:GetCount()>0 then
        if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
            Duel.NegateEffect(0)
            return
        end
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
