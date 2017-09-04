--掠夺生命的恶魔 伊裴尔塔尔
function c60159012.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(c60159012.mfilter),5,2,c60159012.ovfilter,aux.Stringid(60159012,1))
    c:EnableReviveLimit()
	--special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60159012,0))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetCondition(c60159012.thcon)
    e3:SetTarget(c60159012.thtg)
    e3:SetOperation(c60159012.thop)
    c:RegisterEffect(e3)
	--negate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,60159012)
    e2:SetCondition(c60159012.negcon)
    e2:SetCost(c60159012.negcost)
    e2:SetTarget(c60159012.negtg)
    e2:SetOperation(c60159012.negop)
    c:RegisterEffect(e2)
	--indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c60159012.imtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
end
function c60159012.mfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159012.ovfilter(c)
    return c:IsFaceup() and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c60159012.imtg(e,c)
    return ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and not c:IsCode(60159012)
end
function c60159012.thcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c60159012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ev)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,ev)
end
function c60159012.thop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c60159012.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsContains(e:GetHandler()) and Duel.IsChainNegatable(ev)
end
function c60159012.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60159012.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c60159012.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end