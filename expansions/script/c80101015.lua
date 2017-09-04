--刀魂-日本号
function c80101015.initial_effect(c)
    c:SetUniqueOnField(1,0,80101015)
    --synchro summon
    aux.AddSynchroProcedure(c,c80101015.synfilter,aux.NonTuner(c80101015.synfilter2),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(80101015,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetTarget(c80101015.eqtg)
    e1:SetOperation(c80101015.eqop)
    c:RegisterEffect(e1)
    --Pos Change
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetDescription(aux.Stringid(80101015,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetTarget(c80101015.postg)
    e3:SetOperation(c80101015.posop)
    c:RegisterEffect(e3)
    --pierce
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e5:SetCondition(c80101015.damcon)
    e5:SetOperation(c80101015.damop)
    c:RegisterEffect(e5)
end
function c80101015.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c80101015.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c80101015.synfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c80101015.synfilter2(c)
    return c:IsRace(RACE_ZOMBIE)
end
function c80101015.filter(c,ec)
    return c:IsSetCard(0x6400)  and c:IsType(TYPE_EQUIP)  and c:CheckEquipTarget(ec)
end
function c80101015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80101015.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c80101015.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80101015,2))
    local g=Duel.SelectMatchingCard(tp,c80101015.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,c)
    if g:GetCount()>0 then
        Duel.Equip(tp,g:GetFirst(),c)
    end
end
function c80101015.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
    local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c80101015.posop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end


