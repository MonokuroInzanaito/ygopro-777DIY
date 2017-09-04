--夜莺
function c18743212.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69514125,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c18743212.con)
	e1:SetTarget(c18743212.tg)
	e1:SetOperation(c18743212.op)
	c:RegisterEffect(e1)
	--tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73964868,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c18743212.condition)
	e2:SetTarget(c18743212.target)
	e2:SetOperation(c18743212.activate)
	c:RegisterEffect(e2)
end
os=require("os")
function c18743212.filter1(c)
	return c:IsFaceup() and not c:IsAttackBelow(0)
end
function c18743212.con(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
end
function c18743212.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18743212.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local seq=e:GetHandler():GetSequence()
	local g=Group.CreateGroup()
	g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18743212.op(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)==nil then return end
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	Duel.Destroy(tc2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c18743212.filter1,tp,0,LOCATION_MZONE,nil,tc2)
	local tc=g:GetFirst()
	if not tc then return end
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+e:GetHandler():GetFieldID())
	local val=(math.random(0,7))
	Duel.SelectOption(tp,aux.Stringid(18743212,val))
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c18743212.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c18743212.filter(c)
	return c:IsFaceup()
end
function c18743212.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c18743212.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18743212.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18743212.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c18743212.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(7,10))
	Duel.SelectOption(tp,aux.Stringid(18743212,val))
	if tc:IsRelateToEffect(e) and c18743212.filter(tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetOperation(c18743212.desop)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			tc:RegisterEffect(e1)
	end
end
function c18743212.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end