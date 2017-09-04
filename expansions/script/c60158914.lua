--月咏的天巫女 伊裴
function c60158914.initial_effect(c)
    c:EnableReviveLimit()
	--tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60158914,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60158914)
    e1:SetCondition(c60158914.discon)
    e1:SetTarget(c60158914.target)
    e1:SetOperation(c60158914.operation)
    c:RegisterEffect(e1)
    --ritual level
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_RITUAL_LEVEL)
    e2:SetValue(c60158914.rlevel)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_INACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c60158914.chainfilter)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_DISEFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c60158914.chainfilter)
    c:RegisterEffect(e4)
    --cannot disable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISABLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_ONFIELD,0)
    e5:SetTarget(c60158914.distarget)
    c:RegisterEffect(e5)
    --inactivatable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_INACTIVATE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c60158914.efilter)
    c:RegisterEffect(e6)
end
function c60158914.discon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c60158914.filter(c)
    return c:GetLevel()>=10 and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c60158914.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158914.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60158914.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60158914.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60158914.rlevel(e,c)
    local lv=e:GetHandler():GetLevel()
    if c:GetLevel()>=10 then
        local clv=c:GetLevel()
        return lv*65536+clv
    else return lv end
end
function c60158914.chainfilter(e,ct)
    local p=e:GetHandlerPlayer()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tc=te:GetHandler()
    return p==tp and tc:GetType()==TYPE_RITUAL
end
function c60158914.distarget(e,c)
    return c:GetType()==TYPE_RITUAL or c:GetType()==TYPE_RITUAL+TYPE_EQUIP
end
function c60158914.efilter(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return te:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_RITUAL) 
end