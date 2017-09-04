--愤怒的心火 伊裴尔塔尔
function c60159011.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(c60159011.mfilter),4,2)
    c:EnableReviveLimit()
	--destroy&damage
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,60159011)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c60159011.cost)
    e1:SetTarget(c60159011.target)
    e1:SetOperation(c60159011.operation)
    c:RegisterEffect(e1)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159011,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c60159011.cost2)
    e2:SetOperation(c60159011.operation2)
    c:RegisterEffect(e2)
end
function c60159011.mfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
		and e:GetHandler():GetAttackAnnouncedCount()==0 end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c60159011.filter(c)
    return c:IsDestructable()
end
function c60159011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c60159011.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60159011.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c60159011.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60159011.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
        local atk=e:GetHandler():GetBaseAttack()
        if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			if tc:IsType(TYPE_MONSTER) then
				Duel.Damage(1-tp,atk,REASON_EFFECT)
			end
		end
    end
end
function c60159011.filter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c60159011.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159011.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    local g=Duel.SelectMatchingCard(tp,c60159011.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c60159011.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.NegateAttack() then
		Duel.BreakEffect()
        if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetLabelObject(c)
        e1:SetCondition(c60159011.retcon)
        e1:SetOperation(c60159011.retop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        Duel.RegisterEffect(e1,tp)
	end
end
function c60159011.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c60159011.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
