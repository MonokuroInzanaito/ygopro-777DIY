--原罪碎片 暴怒的华烨
function c60158601.initial_effect(c)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60158601)
    e1:SetCondition(c60158601.condition)
    e1:SetTarget(c60158601.target)
    e1:SetOperation(c60158601.operation)
    c:RegisterEffect(e1)
	--get effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158601,1))
    e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_BATTLED)
    e2:SetCondition(c60158601.rmcon)
    e2:SetTarget(c60158601.rmtg)
    e2:SetOperation(c60158601.rmop)
    c:RegisterEffect(e2)
	--cannot remove
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158601,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e3:SetCountLimit(1,6018601)
    e3:SetCost(c60158601.spcost)
    e3:SetTarget(c60158601.sptg)
    e3:SetOperation(c60158601.spop)
    c:RegisterEffect(e3)
end
function c60158601.condition(e,tp,eg,ep,ev,re,r,rp)
    return re and (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsRace(RACE_FIEND))
end
function c60158601.filter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158601.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c60158601.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60158601.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60158601.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60158601.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    e:SetLabelObject(bc)
    return c:GetOriginalRace()==RACE_FIEND
        and bc and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end
function c60158601.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsFaceup() end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(800)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c60158601.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetValue(800)
    c:RegisterEffect(e1)
	if c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
function c60158601.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c60158601.spfilter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158601.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c60158601.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158601.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
