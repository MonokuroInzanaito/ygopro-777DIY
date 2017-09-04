--八枢罪 鸣响
function c60159102.initial_effect(c)
	--copy
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60159102,0))
    e5:SetType(EFFECT_TYPE_ACTIVATE)
    e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCountLimit(1,60159102)
	e5:SetCost(c60159102.cost)
    e5:SetTarget(c60159102.target)
    e5:SetOperation(c60159102.operation)
    c:RegisterEffect(e5)
	--Activate
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159101,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,60159102)
    e2:SetCondition(c60159102.condition)
    e2:SetTarget(c60159102.settg)
    e2:SetOperation(c60159102.setop)
    c:RegisterEffect(e2)
end
function c60159102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159102.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60159102.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local rtc=g:GetFirst()
	if rtc:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(rtc,REASON_COST)
	elseif rtc:IsLocation(LOCATION_ONFIELD) and rtc:IsFacedown() then
		Duel.Remove(rtc,POS_FACEUP,REASON_COST)
	end
	e:SetLabelObject(rtc)
end
function c60159102.cfilter2(c)
	return c:IsSetCard(0x3b25) and c:IsType(TYPE_SPELL) and not c:IsCode(60159102) and c:CheckActivateEffect(true,true,false)~=nil 
		and ((c:IsLocation(LOCATION_HAND) and c:IsAbleToGraveAsCost()) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() and c:IsAbleToGraveAsCost()))
end
function c60159102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local rtc=e:GetLabelObject()
	local te=rtc:CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	rtc:CreateEffectRelation(e)
	e:SetLabelObject(te)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not cg then return end
	local tc=cg:GetFirst()
	while tc do
		tc:CreateEffectRelation(te)
		tc=cg:GetNext()
	end
end
function c60159102.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not cg then return end
		local tc=cg:GetFirst()
		while tc do
			tc:ReleaseEffectRelation(te)
			tc=cg:GetNext()
		end
	end
end
function c60159102.cfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c60159102.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c60159102.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) 
		and eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) 
		and eg:GetFirst():IsSetCard(0x3b25) and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c60159102.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c60159102.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsSSetable() then
        Duel.SSet(tp,c)
        Duel.ConfirmCards(1-tp,c)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end
