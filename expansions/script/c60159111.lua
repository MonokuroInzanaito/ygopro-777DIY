--八枢罪 翡翠饕餮
function c60159111.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,c60159111.mfilter,5,3,c60159111.ovfilter,aux.Stringid(60159111,0),3,c60159111.xyzop)
    c:EnableReviveLimit()
	--summon success
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60159111.atkcon)
    e1:SetOperation(c60159111.sumsuc)
    c:RegisterEffect(e1)
	--equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159111,1))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
    e2:SetCondition(c60159111.eqcon)
    e2:SetTarget(c60159111.eqtg)
    e2:SetOperation(c60159111.eqop)
    c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c60159111.reptg)
    c:RegisterEffect(e3)
	--spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCondition(c60159111.spcon)
    e4:SetTarget(c60159111.sptg)
    e4:SetOperation(c60159111.spop)
    c:RegisterEffect(e4)
end
function c60159111.mfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND)
end
function c60159111.ovfilter(c)
    return c:IsFaceup() and c:GetLevel()==5 and c:IsAttribute(ATTRIBUTE_WIND)
end
function c60159111.cfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c60159111.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159111.cfilter,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,c60159111.cfilter,2,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(60159111,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60159111.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetFlagEffect(60159111)>0
end
function c60159111.cfilter2(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c60159111.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60159111.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
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
function c60159111.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if not c:IsRelateToBattle() or c:IsFacedown() then return false end
    e:SetLabelObject(tc)
    return (tc:IsLocation(LOCATION_GRAVE) or tc:IsLocation(LOCATION_EXTRA)) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and c:IsChainAttackable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c60159111.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local tc=e:GetLabelObject()
    Duel.SetTargetCard(tc)
	if tc:IsLocation(LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0) end
end
function c60159111.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,tc,c,false) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c60159111.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(400)
        tc:RegisterEffect(e2)
		Duel.ChainAttack()
    end
end
function c60159111.eqlimit(e,c)
    return e:GetOwner()==c
end
function c60159111.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and c:GetEquipGroup():IsExists(Card.IsDestructable,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(60159111,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=c:GetEquipGroup():FilterSelect(tp,Card.IsDestructable,1,1,nil)
		Duel.Destroy(g,REASON_COST)
        return true
    else return false end
end
function c60159111.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c60159111.spfilter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60159111.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159111.spfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60159111.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159111.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
