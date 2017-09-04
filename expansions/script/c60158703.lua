--中华少女·缘木
function c60158703.initial_effect(c)
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,60158703)
    e1:SetCondition(c60158703.spcon)
	e1:SetValue(1)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c60158703.descon)
    e2:SetOperation(c60158703.desop)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetTarget(c60158703.tg)
    e3:SetOperation(c60158703.op)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
	--
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetHintTiming(0,0x1e0)
    e5:SetRange(LOCATION_HAND)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCountLimit(1,6018703)
    e5:SetCost(c60158703.cost)
    e5:SetTarget(c60158703.target)
    e5:SetOperation(c60158703.operation)
    c:RegisterEffect(e5)
end
c60158703.card_code_list={60158702}
function c60158703.filter(c)
    return c:IsFaceup() and c:IsCode(60158702)
end
function c60158703.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c60158703.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60158703.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c60158703.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonLocation()==LOCATION_GRAVE then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(60151601,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
function c60158703.filter2(c)
    return c:IsSetCard(0x6b28) and c:IsFaceup()
end
function c60158703.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c60158703.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158703.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		and Duel.IsExistingMatchingCard(c60158703.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c60158703.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE,g,g:GetCount(),0,0)
end
function c60158703.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(tc:GetAttack()/2)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
		if not tc:IsType(TYPE_XYZ) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(tc:GetLevel()/2)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		else
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_RANK)
			e3:SetValue(tc:GetRank()/2)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
        tc=g:GetNext()
    end
end
function c60158703.filter4(c)
    return not (c:IsSetCard(0x6b28) and c:IsFaceup())
end
function c60158703.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158703.filter2,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c60158703.filter4,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c60158703.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60158703.filter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c60158703.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60158703.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetValue(c60158703.efilter)
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e3:SetOwnerPlayer(tp)
        tc:RegisterEffect(e3)
    end
end
function c60158703.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
