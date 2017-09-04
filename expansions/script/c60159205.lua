--澄 圣诞夜
function c60159205.initial_effect(c)
	c:EnableUnsummonable()
    --splimit
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e11:SetCode(EFFECT_SPSUMMON_CONDITION)
    e11:SetValue(c60159205.splimit)
    c:RegisterEffect(e11)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e1:SetValue(c60159205.xyzlimit)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e2)
	local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e3)
	--Special Summon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c60159205.sscon)
    e4:SetTarget(c60159205.sstg)
    e4:SetOperation(c60159205.ssop)
    c:RegisterEffect(e4)
	--effect gain
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_BE_MATERIAL)
    e5:SetCondition(c60159205.efcon)
    e5:SetOperation(c60159205.efop)
    c:RegisterEffect(e5)
end
function c60159205.splimit(e,se,sp,st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c60159205.xyzlimit(e,c)
    if not c then return false end
    return not (c:IsSetCard(0x5b25) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION)))
end
function c60159205.filter(c)
    return c:IsType(TYPE_MONSTER)
end
function c60159205.sscon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c60159205.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c60159205.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60159205.ssop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60159205.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ or r==REASON_SYNCHRO or r==REASON_FUSION
end
function c60159205.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(60159205,1))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCountLimit(1)
    e1:SetCondition(c60159205.drcon2)
    e1:SetTarget(c60159205.drtg)
    e1:SetOperation(c60159205.drop)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e2,true)
    end
end
function c60159205.drcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO or e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
		or e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION 
end
function c60159205.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c60159205.drop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end