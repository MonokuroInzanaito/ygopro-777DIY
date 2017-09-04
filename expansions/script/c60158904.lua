--收割生命的恶魔
function c60158904.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60158904.mfilter,7,3)
	c:EnableReviveLimit()
	--attack all
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(c60158904.atkfilter)
    c:RegisterEffect(e2)
	--special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158904,0))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetCondition(c60158904.thcon)
    e3:SetTarget(c60158904.thtg)
	e3:SetCost(c60158904.discost)
    e3:SetOperation(c60158904.thop)
    c:RegisterEffect(e3)
	--attack up
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60158904,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetCondition(c60158904.condition)
    e1:SetOperation(c60158904.operation)
    c:RegisterEffect(e1)
end
function c60158904.mfilter(c)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c60158904.atkfilter(e,c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c60158904.thcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and Duel.GetAttackTarget()==nil
end
function c60158904.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
    Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk/2)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function c60158904.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60158904.thop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c60158904.condition(e,tp,eg,ep,ev,re,r,rp)
    local atk=e:GetHandler():GetBattleTarget()
    local lv=e:GetHandler():GetRank()
    if atk:IsType(TYPE_XYZ) then
        local rk=atk:GetRank()
        return e:GetHandler():IsRelateToBattle() and e:GetHandler():IsPosition(POS_FACEUP) and rk>lv and atk:IsPosition(POS_FACEUP)
    else
        local rk=atk:GetLevel()
        return e:GetHandler():IsRelateToBattle() and e:GetHandler():IsPosition(POS_FACEUP) and rk>lv and atk:IsPosition(POS_FACEUP)
    end
end

function c60158904.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local atk=c:GetBattleTarget()
        if atk:IsType(TYPE_XYZ) then
            local rk=atk:GetRank()
            local lv=e:GetHandler():GetRank()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(rk*100)
            e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
            c:RegisterEffect(e1)
        else
            local rk=atk:GetLevel()
            local lv=e:GetHandler():GetRank()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(rk*100)
            e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
            c:RegisterEffect(e1)
        end
    end
end