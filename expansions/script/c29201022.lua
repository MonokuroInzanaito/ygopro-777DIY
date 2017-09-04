--镜世录 年幼之狼
function c29201022.initial_effect(c)
    --special summon
    local e17=Effect.CreateEffect(c)
    e17:SetType(EFFECT_TYPE_FIELD)
    e17:SetCode(EFFECT_SPSUMMON_PROC)
    e17:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e17:SetRange(LOCATION_HAND)
    e17:SetCondition(c29201022.spcon)
    c:RegisterEffect(e17)
    --send 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201022,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_DAMAGE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(c29201022.recon)
    e1:SetTarget(c29201022.rectg)
    e1:SetOperation(c29201022.recop)
    c:RegisterEffect(e1)
    --redirect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(LOCATION_REMOVED)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x63e0))
    c:RegisterEffect(e2)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201022.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_SZONE)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201022.splimit)
    c:RegisterEffect(e13)
end
function c29201022.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:GetCode()~=29201022
end
function c29201022.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c29201022.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29201022.recon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c29201022.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:GetLocation()==LOCATION_GRAVE end
end
function c29201022.recop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:GetLocation()~=LOCATION_GRAVE then return false end
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
	end
end
function c29201022.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
