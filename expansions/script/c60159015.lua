--行走的死亡 哲尔尼亚斯
function c60159015.initial_effect(c)
	c:SetUniqueOnField(1,1,60159015)
	--synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c60159015.mfilter),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
	--to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159015,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(c60159015.thcon)
    e1:SetTarget(c60159015.thtg)
    e1:SetOperation(c60159015.thop)
    c:RegisterEffect(e1)
	--battle indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	--indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
	e3:SetCondition(c60159015.condition)
    c:RegisterEffect(e3)
	--negate
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetOperation(c60159015.negop1)
    c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetOperation(c60159015.negop2)
    c:RegisterEffect(e7)
end
function c60159015.mfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159015.thcon(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    return phase==PHASE_STANDBY
end
function c60159015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
end
function c60159015.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*500,REASON_EFFECT)
end
function c60159015.condition(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_BATTLE
end
function c60159015.negop1(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
    if d~=nil then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			d:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			d:RegisterEffect(e2)
    end
end
function c60159015.negop2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
	local ph=Duel.GetCurrentPhase()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_BATTLE)
        a:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_BATTLE)
        a:RegisterEffect(e2)
end