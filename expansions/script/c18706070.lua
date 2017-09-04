--封解主 星宮六喰
function c18706070.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xabb),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(aux.Stringid(18706070,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(18706070,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c18706070.sprcon)
	e2:SetOperation(c18706070.sprop)
	c:RegisterEffect(e2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52687916,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c18706070.target2)
	e1:SetOperation(c18706070.operation2)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18706070,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c18706070.target)
	e1:SetOperation(c18706070.operation)
	c:RegisterEffect(e1)
end
function c18706070.chlimit(e,ep,tp)
	return tp==ep 
end
function c18706070.sprfilter(c,tp)
	return  c:IsFaceup() and c:IsSetCard(0xabb) and c:IsReleasable()
		and c:GetLevel()==3
end
function c18706070.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c18706070.sprfilter,tp,LOCATION_MZONE,0,2,nil,tp)
end
function c18706070.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c18706070.sprfilter,tp,LOCATION_MZONE,0,2,2,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c18706070.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(54719828,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.SetChainLimitTillChainEnd(c18706070.chlimit)
end
function c18706070.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	if e:GetLabel()==0 then
		e4:SetValue(c18706070.efilter1)
	elseif e:GetLabel()==1 then
		e4:SetValue(c18706070.efilter2)
	else
		e4:SetValue(c18706070.efilter3)
	end
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	if e:GetLabel()==0 then
		e5:SetDescription(aux.Stringid(18706070,2)) 
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetTarget(c18706070.distarget1)
	elseif e:GetLabel()==1 then
		e5:SetDescription(aux.Stringid(18706070,3))
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetTarget(c18706070.distarget2)
	else
		e5:SetDescription(aux.Stringid(18706070,4))
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetTarget(c18706070.distarget3)
	end
	e5:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e5)
	--inactivatable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	if e:GetLabel()==0 then
		e6:SetDescription(aux.Stringid(18706070,2))
		e6:SetValue(c18706070.efilter1)
	elseif e:GetLabel()==1 then
		e6:SetDescription(aux.Stringid(18706070,3))
		e6:SetValue(c18706070.efilter2)
	else
		e6:SetDescription(aux.Stringid(18706070,4))
		e6:SetValue(c18706070.efilter3)
	end
	e6:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e6)
end
function c18706070.distarget1(e,c)
	return c:GetType()==TYPE_MONSTER
end
function c18706070.distarget2(e,c)
	return c:GetType()==TYPE_SPELL
end
function c18706070.distarget3(e,c)
	return c:GetType()==TYPE_TRAP
end
function c18706070.efilter1(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and (te:GetActiveType()==TYPE_MONSTER or te:GetHandler():IsType(TYPE_MONSTER))
end
function c18706070.efilter2(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetActiveType()==TYPE_SPELL
end
function c18706070.efilter3(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetActiveType()==TYPE_TRAP
end
function c18706070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD)  end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
end
function c18706070.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
			c:SetCardTarget(tc)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(c18706070.rcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			else  if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e)  then
			c:SetCardTarget(tc)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetCondition(c18706070.rcon)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetCondition(c18706070.rcon)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			else
			c:SetCardTarget(tc)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCondition(c18706070.rcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
		end
		tc=g:GetNext()
	end
end
function c18706070.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end