--名刀-物吉贞宗
function c80101018.initial_effect(c)
    c:SetUniqueOnField(1,0,80101018)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c80101018.target)
    e1:SetOperation(c80101018.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EQUIP_LIMIT)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetValue(c80101018.eqlimit)
    c:RegisterEffect(e5)
    --salvage
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(80101018,1))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,81101106)
    e10:SetCost(c80101018.cost)
    e10:SetTarget(c80101018.tg)
    e10:SetOperation(c80101018.op)
    c:RegisterEffect(e10)
    --atkdown
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_EQUIP)
    e0:SetCode(EFFECT_UPDATE_ATTACK)
    e0:SetCondition(c80101018.flcon)
    e0:SetValue(400)
    c:RegisterEffect(e0)
    --immune effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_ONFIELD,0)
    --e4:SetCondition(c80101018.flcon)
    e4:SetTarget(c80101018.etarget)
    e4:SetValue(c80101018.efilter)
    c:RegisterEffect(e4)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101018,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,80101018)
    e2:SetCondition(c80101018.thcon)
    e2:SetCost(c80101018.cost)
    e2:SetTarget(c80101018.thtg)
    e2:SetOperation(c80101018.thop)
    c:RegisterEffect(e2)
end
function c80101018.flcon(e)
	return (e:GetHandler():GetEquipTarget():IsSetCard(0x5400) 
		and e:GetHandler():GetEquipTarget():IsType(TYPE_SYNCHRO)) 
		 or e:GetHandler():GetEquipTarget():IsCode(80101017)
end
function c80101018.cfilter(c)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x5400) and c:IsType(TYPE_MONSTER)
end
function c80101018.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c80101018.cfilter,1,nil)
end
function c80101018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c80101018.spfilter(c,e,tp)
    return c:IsSetCard(0x5400) and not c:IsCode(80101017) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c80101018.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c80101018.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c80101018.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()~=0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c80101018.thfilter(c)
    return c:IsCode(80101017) and c:IsAbleToHand()
end
function c80101018.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101018.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80101018.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80101018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80101018.etarget(e,c)
    return c:IsSetCard(0x6400) and c:IsType(TYPE_SPELL)
end
function c80101018.efilter(e,re)
    return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c80101018.eqlimit(e,c)
    return c:IsSetCard(0x5400)
end
function c80101018.eqfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x5400)
end
function c80101018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80101018.eqfilter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80101018.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80101018.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80101018.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
        Duel.Equip(tp,c,tc)
    end
end
