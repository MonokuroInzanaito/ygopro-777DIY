--镜世录 念缚灵
function c29201028.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c29201028.matfilter,3,2,nil,nil,5)
    c:EnableReviveLimit()
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c29201028.atkval)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCondition(c29201028.spcon)
    e3:SetTarget(c29201028.sptg)
    e3:SetOperation(c29201028.spop)
    c:RegisterEffect(e3)
    --[[--Attach
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201028,1))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCountLimit(1)
    e1:SetCondition(c29201028.xyzcon)
    e1:SetTarget(c29201028.xyztg)
    e1:SetOperation(c29201028.xyzop)
    c:RegisterEffect(e1)]]
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201028,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(c29201028.target)
    e1:SetOperation(c29201028.operation)
    c:RegisterEffect(e1)
end
function c29201028.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c29201028.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c29201028.matfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER)
end
function c29201028.atkval(e,c)
    return c:GetOverlayCount()*500
end
function c29201028.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetOverlayCount()
    e:SetLabel(ct)
    return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE and ct>0
end
function c29201028.spfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) 
end
function c29201028.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29201028.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c29201028.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local ct=e:GetLabel()
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ct>ft then ct=ft end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectTarget(tp,c29201028.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
end
function c29201028.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    if ft<g:GetCount() then return end
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local e1=Effect.CreateEffect(tc)
            e1:SetCode(EFFECT_CHANGE_TYPE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fc0000)
            e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
            tc:RegisterEffect(e1)
            Duel.RaiseEvent(tc,EVENT_CUSTOM+29201000,e,0,tp,0,0)
            tc=g:GetNext()
		end
    end
end
--[[
function c29201028.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if not c:IsRelateToBattle() or c:IsFacedown() then return false end
    e:SetLabelObject(tc)
    return tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE )and c:IsType(TYPE_XYZ) 
end
function c29201028.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local tc=e:GetLabelObject()
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c29201028.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
]]

