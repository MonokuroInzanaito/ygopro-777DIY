--八枢罪 墨青怠惰
function c60159116.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,c60159116.mfilter,5,3,c60159116.ovfilter,aux.Stringid(60159116,0),3,c60159116.xyzop)
    c:EnableReviveLimit()
	--summon success
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60159116.atkcon)
    e1:SetOperation(c60159116.sumsuc)
    c:RegisterEffect(e1)
	--control
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e2)
	--immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetOperation(c60159116.atkop)
    c:RegisterEffect(e3)
	--negate
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetOperation(c60159116.negop1)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetOperation(c60159116.negop2)
    c:RegisterEffect(e7)
	--spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCondition(c60159116.spcon)
    e4:SetTarget(c60159116.sptg)
    e4:SetOperation(c60159116.spop)
    c:RegisterEffect(e4)
end
function c60159116.mfilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER)
end
function c60159116.ovfilter(c)
    return c:IsFaceup() and c:GetLevel()==5 and c:IsAttribute(ATTRIBUTE_WATER)
end
function c60159116.cfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c60159116.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159116.cfilter,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,c60159116.cfilter,2,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60159116,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60159116.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetFlagEffect(60159116)>0
end
function c60159116.cfilter2(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c60159116.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60159116.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc2=g:GetFirst()
		while tc2 do
			if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
			tc2=g:GetNext()
		end
        Duel.Remove(g,POS_FACEUP,REASON_RULE)
    end
end
function c60159116.atkop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c60159116.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
    e:GetHandler():RegisterEffect(e1)
end
function c60159116.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c60159116.negop1(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d~=nil then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_DAMAGE)
        d:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_DAMAGE)
        d:RegisterEffect(e2)
    end
end
function c60159116.negop2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_DAMAGE)
        a:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x57a0000+RESET_PHASE+PHASE_DAMAGE)
        a:RegisterEffect(e2)
end
function c60159116.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c60159116.spfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60159116.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159116.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60159116.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159116.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end