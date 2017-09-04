--魂火的余烬 佐仓杏子
function c60152005.initial_effect(c)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152005,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,6012005)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetCondition(c60152005.condition)
    e1:SetTarget(c60152005.target)
    e1:SetOperation(c60152005.activate)
    c:RegisterEffect(e1)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152005,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,60152005)
    e3:SetTarget(c60152005.sptg)
    e3:SetOperation(c60152005.spop)
    c:RegisterEffect(e3)
end
function c60152005.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c60152005.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60152005.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c60152005.dfilter(c)
    return c:IsFaceup() and c:GetAttack()<1800
end
function c60152005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152005.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(c60152005.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c60152005.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c60152005.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
function c60152005.filter(c,e,tp)
    return c:IsSetCard(0x6b25) and c:GetCode()~=60152005
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c60152005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60152005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c60152005.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60152005.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c60152005.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c60152005.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA)
end