--刀魂-一期一会
function c80101013.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.NonTuner(Card.IsSetCard,0x5400),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(80101013,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c80101013.condition)
    e1:SetTarget(c80101013.target)
    e1:SetOperation(c80101013.operation)
    c:RegisterEffect(e1)
    --[[destroy replace
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_ONFIELD)
    e5:SetCountLimit(1,80151013)
    e5:SetTarget(c80101013.reptg)
    c:RegisterEffect(e5)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetTarget(c80101013.destg)
    e2:SetValue(c80101013.value)
    c:RegisterEffect(e2)]]
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,81101013)
    e2:SetTarget(c80101013.reptg)
    e2:SetValue(c80101013.repval)
    e2:SetOperation(c80101013.repop)
    c:RegisterEffect(e2)
    --change effect
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80101013,1))
    e0:SetType(EFFECT_TYPE_QUICK_O)
    e0:SetCode(EVENT_CHAINING)
    e0:SetRange(LOCATION_MZONE)
    e0:SetCountLimit(1,80101013)
    e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e0:SetCondition(c80101013.chcon)
    e0:SetTarget(c80101013.chtg)
    e0:SetOperation(c80101013.chop)
    c:RegisterEffect(e0)
end
function c80101013.chcon(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
    --return re~=e and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c80101013.cfilter(c)
    return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c80101013.filter8(c)
    return c:IsFaceup() 
end
function c80101013.desfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c80101013.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80101013.filter8,rp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(c80101013.desfilter,tp,LOCATION_SZONE,0,1,nil) end
end
function c80101013.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c80101013.repop0)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectMatchingCard(tp,c80101013.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
    Duel.Destroy(dg,REASON_EFFECT)
end
function c80101013.repop0(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
        c:CancelToGrave(false)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c80101013.filter8,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end
--[[
function c80101013.dfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
        and c:IsSetCard(0x5400) and c:IsReason(REASON_EFFECT)
end
function c80101013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) and eg:IsExists(c80101013.dfilter,1,nil,tp) end
    if Duel.SelectYesNo(tp,aux.Stringid(80101013,2)) then
        local g=eg:Filter(c80101013.dfilter,nil,tp)
        if g:GetCount()==1 then
            e:SetLabelObject(g:GetFirst())
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
            local cg=g:Select(tp,1,1,nil)
            e:SetLabelObject(cg:GetFirst())
        end
        Duel.PayLPCost(tp,800)
        return true
    else return false end
end
function c80101013.value(e,c)
    return c==e:GetLabelObject()
end
]]
function c80101013.repfilter(c,tp)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c80101013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) and eg:IsExists(c80101013.repfilter,1,nil,tp) end
    return Duel.SelectYesNo(tp,aux.Stringid(80101013,2))
end
function c80101013.repval(e,c)
    return c80101013.repfilter(c,e:GetHandlerPlayer())
end
function c80101013.repop(e,tp,eg,ep,ev,re,r,rp)
     Duel.PayLPCost(tp,800)
end
--[[
function c80101013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and Duel.CheckLPCost(tp,800) end
    if Duel.SelectYesNo(tp,aux.Stringid(80101013,2)) then
        Duel.PayLPCost(tp,800)
        return true
    else return false end
end]]
function c80101013.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c80101013.filter(c,e,tp,ec)
    return c:IsSetCard(0x6400)  and c:IsType(TYPE_EQUIP) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c80101013.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80101013.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetMatchingGroup(c80101013.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g1=g:Select(tp,1,1,nil)
    g:RemoveCard(g1:GetFirst())
    if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80101013,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
    end
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c80101013.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if ft<g:GetCount() then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,true,true)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
end
