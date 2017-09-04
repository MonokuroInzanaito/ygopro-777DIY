--时溯的公主 流烨
function c60158919.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,nil,4,2)
    c:EnableReviveLimit()
	--
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60158919.condition)
    e1:SetTarget(c60158919.target)
    e1:SetOperation(c60158919.operation)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(c60158919.tglimit)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c60158919.tglimit)
    c:RegisterEffect(e3)
end
function c60158919.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsOnField() and (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) 
		and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_PENDULUM)
end
function c60158919.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return re:GetHandler():IsDestructable() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c60158919.operation(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoHand(eg,nil,REASON_EFFECT)
    end
end
function c60158919.tglimit(e,c)
    return c:IsType(TYPE_PENDULUM)
end
