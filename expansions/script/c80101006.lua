--名刀-骨喰
function c80101006.initial_effect(c)
    c:SetUniqueOnField(1,0,80101006)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c80101006.target)
    e1:SetOperation(c80101006.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_EQUIP_LIMIT)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetValue(c80101006.eqlimit)
    c:RegisterEffect(e7)
	--[[
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(ea]]
    --atkdown
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(c80101006.flcon)
    e2:SetValue(500)
    c:RegisterEffect(e2)
    --cannot be destroyed
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_EQUIP)
    e8:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e8:SetCondition(c80101006.flcon)
    e8:SetValue(c80101006.valcon)
    e8:SetCountLimit(1)
    c:RegisterEffect(e8)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80101006,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,80101006)
    e3:SetTarget(c80101006.destg)
    e3:SetOperation(c80101006.desop)
    c:RegisterEffect(e3)
    --salvage
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(80101006,1))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,81101106)
    e10:SetCost(c80101006.cost)
    e10:SetTarget(c80101006.tg)
    e10:SetOperation(c80101006.op)
    c:RegisterEffect(e10)
end
c80101006.swt_number=1
function c80101006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c80101006.thfilter(c)
    return c:IsCode(80101001) and c:IsAbleToHand()
end
function c80101006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101006.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80101006.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101006.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c80101006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c80101006.filter(chkc) end
    local eq=e:GetHandler():GetEquipTarget()
    if chk==0 then return eq and eq:IsAttackAbove(300)
        and Duel.IsExistingTarget(c80101006.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c80101006.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80101006.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local eq=c:GetEquipTarget()
    if not c:IsRelateToEffect(e) or eq:IsImmuneToEffect(e) or not eq:IsAttackAbove(300) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-300)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    eq:RegisterEffect(e1)
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c80101006.flcon(e)
	return (e:GetHandler():GetEquipTarget():IsSetCard(0x5400) and e:GetHandler():GetEquipTarget():IsType(TYPE_SYNCHRO)) 
		or e:GetHandler():GetEquipTarget():IsCode(80101001)
end
function c80101006.valcon(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c80101006.eqlimit(e,c)
    return c:IsSetCard(0x5400)
end
function c80101006.eqfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80101006.eqfilter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80101006.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80101006.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80101006.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
        Duel.Equip(tp,c,tc)
    end
end
