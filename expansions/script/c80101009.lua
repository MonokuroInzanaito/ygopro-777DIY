--名刀-五虎退
function c80101009.initial_effect(c)
    c:SetUniqueOnField(1,0,80101009)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c80101009.target)
    e1:SetOperation(c80101009.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c80101009.eqlimit)
    c:RegisterEffect(e3)
    --Indes
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_EQUIP)
    ea:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    ea:SetCondition(c80101009.flcon)
    ea:SetValue(1)
    c:RegisterEffect(ea)
    --salvage
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(80101009,1))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,81101106)
    e10:SetCost(c80101009.cost)
    e10:SetTarget(c80101009.tg)
    e10:SetOperation(c80101009.op)
    c:RegisterEffect(e10)
    --atkdown
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(c80101009.flcon)
    e2:SetValue(300)
    c:RegisterEffect(e2)
    --spsummon
    local e14=Effect.CreateEffect(c)
    e14:SetDescription(aux.Stringid(80101009,0))
    e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e14:SetType(EFFECT_TYPE_IGNITION)
    e14:SetRange(LOCATION_SZONE)
    e14:SetCountLimit(1,80101009)
    e14:SetCost(c80101009.spcost)
    e14:SetOperation(c80101009.spop)
    c:RegisterEffect(e14)
end
function c80101009.cffilter(c)
    return c:IsSetCard(0x6400) and not c:IsCode(80101009)
end
function c80101009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101009.cffilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c80101009.cffilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetCode())
end
function c80101009.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    local code=e:GetLabel()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 1)
    end
end
function c80101009.flcon(e)
	return (e:GetHandler():GetEquipTarget():IsSetCard(0x5400) and e:GetHandler():GetEquipTarget():IsType(TYPE_SYNCHRO)) 
		or e:GetHandler():GetEquipTarget():IsCode(80101004)
end
function c80101009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c80101009.thfilter(c)
    return c:IsCode(80101004) and c:IsAbleToHand()
end
function c80101009.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101009.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80101009.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101009.eqlimit(e,c)
    return c:IsSetCard(0x5400)
end
function c80101009.eqfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80101009.eqfilter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80101009.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80101009.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80101009.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
        Duel.Equip(tp,c,tc)
    end
end


