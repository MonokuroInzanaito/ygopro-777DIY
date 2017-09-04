--澄 丢失的勇气
function c60159202.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e1:SetValue(c60159202.xyzlimit)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e2)
	local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e3)
	--special summon
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SPSUMMON_PROC)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,60159202)
    e4:SetCondition(c60159202.spcon)
    c:RegisterEffect(e4)
	--special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60159202,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c60159202.spcon2)
    e5:SetTarget(c60159202.sptg)
    e5:SetOperation(c60159202.spop)
    c:RegisterEffect(e5)
end
function c60159202.xyzlimit(e,c)
    if not c then return false end
    return not (c:IsSetCard(0x5b25) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION)))
end
function c60159202.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:GetCode()~=60159202
end
function c60159202.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c60159202.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60159202.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c60159202.filter2(c,e,tp)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159202.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60159202.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c60159202.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60159202.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end