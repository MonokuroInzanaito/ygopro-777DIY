--名刀-前田
function c80101010.initial_effect(c)
    c:SetUniqueOnField(1,0,80101010)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c80101010.target)
    e1:SetOperation(c80101010.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c80101010.eqlimit)
    c:RegisterEffect(e3)
    --salvage
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(80101010,1))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,81101106)
    e10:SetCost(c80101010.cost)
    e10:SetTarget(c80101010.tg)
    e10:SetOperation(c80101010.op)
    c:RegisterEffect(e10)
    --atkdown
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_EQUIP)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetCondition(c80101010.flcon)
    e9:SetValue(500)
    c:RegisterEffect(e9)
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(c80101010.discon)
    e4:SetOperation(c80101010.disop)
    c:RegisterEffect(e4)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101010,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,80101006)
    e2:SetTarget(c80101010.sptg)
    e2:SetOperation(c80101010.spop)
    c:RegisterEffect(e2)
end
function c80101010.discon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and ec:GetControler()==tp and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
		and c80101010.flcon(e)
end
function c80101010.disop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetEquipTarget():GetBattleTarget()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e2)
end
function c80101010.flcon(e)
	return (e:GetHandler():GetEquipTarget():IsSetCard(0x5400) and e:GetHandler():GetEquipTarget():IsType(TYPE_SYNCHRO)) 
		or e:GetHandler():GetEquipTarget():IsCode(80101005)
end
function c80101010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c80101010.thfilter(c)
    return c:IsCode(80101005) and c:IsAbleToHand()
end
function c80101010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101010.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80101010.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101010.eqlimit(e,c)
    return c:IsSetCard(0x5400)
end
function c80101010.eqfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80101010.eqfilter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80101010.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80101010.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80101010.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
        Duel.Equip(tp,c,tc)
    end
end
function c80101010.filter(c,e,tp)
    return c:IsSetCard(0x5400) and c:IsAbleToDeck() and c:GetLevel()>0
        and Duel.IsExistingTarget(c80101010.spfilter,tp,LOCATION_HAND,0,1,nil,c:GetLevel(),e,tp)
end
function c80101010.spfilter(c,lv,e,tp)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80101010.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c80101010.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c80101010.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c80101010.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local lv=tc:GetLevel()
    if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80101010.spfilter,tp,LOCATION_HAND,0,1,1,nil,lv,e,tp)
    if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end



