--地耀团-占星师 奥萝拉
function c29201101.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_DESTROY_REPLACE)
	ea:SetRange(LOCATION_PZONE)
	ea:SetTarget(c29201101.reptg)
	ea:SetValue(c29201101.repval)
	ea:SetOperation(c29201101.repop)
	c:RegisterEffect(ea)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c29201101.splimit)
	c:RegisterEffect(e2)
	--send to grave
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(29201101,2))
    e10:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_CHANGE_POS)
	e10:SetOperation(c29201101.operation5)
	c:RegisterEffect(e10)
	--pos
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(29201101,4))
    e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_CHANGE_POS)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c29201101.poscon5)
	e11:SetTarget(c29201101.postg5)
	e11:SetOperation(c29201101.posop5)
	c:RegisterEffect(e11)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201101,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,29201107)
    e1:SetTarget(c29201101.sumtg)
    e1:SetOperation(c29201101.sumop)
    c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
    --special summon
    local e15=Effect.CreateEffect(c)
    e15:SetDescription(aux.Stringid(29201101,0))
    e15:SetType(EFFECT_TYPE_FIELD)
    e15:SetCode(EFFECT_SPSUMMON_PROC)
    e15:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e15:SetRange(LOCATION_HAND)
    e15:SetCountLimit(1,29201101)
    e15:SetCondition(c29201101.spcon)
    e15:SetOperation(c29201101.spop)
    c:RegisterEffect(e15)
end
function c29201101.spfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and not c:IsCode(29201101) and c:IsAbleToHandAsCost()
end
function c29201101.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c29201101.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29201101.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c29201101.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c29201101.filter(c,e,tp)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201101.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201101.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29201101.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201101.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c29201101.cfilter(c,tp)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return ((np==POS_FACEUP_DEFENSE and pp==POS_FACEUP_ATTACK) or (bit.band(pp,POS_DEFENSE)~=0 and np==POS_FACEUP_ATTACK))
		and c:IsControler(tp) and c:IsSetCard(0x33e1)
end
function c29201101.poscon5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29201101.cfilter,1,nil,tp)
end
function c29201101.postg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c29201101.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29201101.posop5(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c29201101.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c29201101.operation5(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(800)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(800)
        e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
function c29201101.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201101.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x33e1)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201101.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c29201101.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(29201101,3))
end
function c29201101.repval(e,c)
	return c29201101.repfilter(c,e:GetHandlerPlayer())
end
function c29201101.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
