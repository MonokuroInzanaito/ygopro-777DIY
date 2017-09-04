--红色骑士团·暗黑太阳神
function c60158821.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5b28),4,2)
    c:EnableReviveLimit()
	--copy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(6511113,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,60158821)
    e1:SetCondition(c60158821.condition)
    e1:SetCost(c60158821.cost)
    e1:SetTarget(c60158821.target)
    e1:SetOperation(c60158821.operation)
    c:RegisterEffect(e1)
	--tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158821,2))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,6018821)
    e3:SetCondition(c60158821.thcon)
    e3:SetTarget(c60158821.thtg)
    e3:SetOperation(c60158821.thop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60158821,2))
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,6018821)
    e4:SetCondition(c60158821.con)
    e4:SetTarget(c60158821.thtg)
    e4:SetOperation(c60158821.thop)
    c:RegisterEffect(e4)
end
function c60158821.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.CheckEvent(EVENT_CHAINING)
end
function c60158821.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    if chk==0 then return e:GetHandler():GetFlagEffect(60158821)==0 end
    e:GetHandler():RegisterFlagEffect(60158821,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60158821.filter1(c)
    return c:GetType()==TYPE_SPELL and c:IsAbleToGraveAsCost()
        and c:CheckActivateEffect(true,true,true)~=nil
end
function c60158821.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
            and Duel.IsExistingMatchingCard(c60158821.filter1,tp,LOCATION_HAND,0,1,nil)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60158821.filter1,tp,LOCATION_HAND,0,1,1,nil)
    local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c60158821.operation(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if not te then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c60158821.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_XYZ and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c60158821.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0) and re:GetHandler():IsSetCard(0x5b28)
end
function c60158821.thfilter(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60158821.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158821.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60158821.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60158821.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
