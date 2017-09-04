--八枢罪 暗绛诱惑
function c60159112.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,c60159112.mfilter,5,3,c60159112.ovfilter,aux.Stringid(60159112,0),3,c60159112.xyzop)
    c:EnableReviveLimit()
	--summon success
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60159112.atkcon)
    e1:SetOperation(c60159112.sumsuc)
    c:RegisterEffect(e1)
	--battle target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(aux.imval1)
    c:RegisterEffect(e2)
	--pos
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1)
    e3:SetTarget(c60159112.postg)
    e3:SetOperation(c60159112.posop)
    c:RegisterEffect(e3)
	--spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCondition(c60159112.spcon)
    e4:SetTarget(c60159112.sptg)
    e4:SetOperation(c60159112.spop)
    c:RegisterEffect(e4)
end
function c60159112.mfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function c60159112.ovfilter(c)
    return c:IsFaceup() and c:GetLevel()==5 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c60159112.cfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c60159112.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159112.cfilter,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,c60159112.cfilter,2,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60159112,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60159112.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetFlagEffect(60159112)>0
end
function c60159112.cfilter2(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c60159112.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60159112.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
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
function c60159112.atkcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60159112.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c60159112.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
        local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(60159112,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
end

function c60159112.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c60159112.spfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60159112.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159112.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60159112.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159112.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end