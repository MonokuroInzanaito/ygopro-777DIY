--八枢罪 灿烂忧郁
function c60159114.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,c60159114.mfilter,5,3,c60159114.ovfilter,aux.Stringid(60159114,0),3,c60159114.xyzop)
    c:EnableReviveLimit()
	--summon success
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60159114.atkcon)
    e1:SetOperation(c60159114.sumsuc)
    c:RegisterEffect(e1)
	--indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c60159114.efilter)
    c:RegisterEffect(e2)
	--replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c60159114.condition)
    e3:SetTarget(c60159114.target)
    e3:SetOperation(c60159114.operation)
    c:RegisterEffect(e3)
	--spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCondition(c60159114.spcon)
    e4:SetTarget(c60159114.sptg)
    e4:SetOperation(c60159114.spop)
    c:RegisterEffect(e4)
end
function c60159114.mfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60159114.ovfilter(c)
    return c:IsFaceup() and c:GetLevel()==5 and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60159114.cfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c60159114.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159114.cfilter,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,c60159114.cfilter,2,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60159114,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60159114.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetFlagEffect(60159114)>0
end
function c60159114.cfilter2(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c60159114.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60159114.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
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
function c60159114.efilter(e,re,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    return not g:IsContains(e:GetHandler())
end
function c60159114.condition(e,tp,eg,ep,ev,re,r,rp)
    if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()~=1 then return false end
    local tc=g:GetFirst()
    e:SetLabelObject(tc)
    return tc:IsOnField()
end

function c60159114.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
    return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c60159114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tf=re:GetTarget()
    local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
    if chkc then return chkc:IsOnField() and c60159114.filter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
    if chk==0 then return Duel.IsExistingTarget(c60159114.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c60159114.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c60159114.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangeTargetCard(ev,Group.FromCards(tc))
    end
end
function c60159114.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c60159114.spfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60159114.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159114.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60159114.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159114.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end