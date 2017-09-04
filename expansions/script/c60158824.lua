--红色骑士团·死神
function c60158824.initial_effect(c)
	c:SetUniqueOnField(1,1,60158824)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(c60158824.sfilter))
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c60158824.sumsuc)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c60158824.acop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c60158824.acop2)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,60158824+EFFECT_COUNT_CODE_DUEL)
	e5:SetCost(c60158824.atkcost)
	e5:SetOperation(c60158824.atkop)
	c:RegisterEffect(e5)
end
function c60158824.sfilter(c)
	return c:IsSetCard(0x5b28) and c:IsType(TYPE_SYNCHRO)
end
function c60158824.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(60158824,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60158824.acopfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsReason(REASON_EFFECT) and c:IsControler(1-tp)
end
function c60158824.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:Filter(c60158824.acopfilter,nil,tp)
	if ct:GetCount()>0 then
		local tc=ct:GetFirst()
		while tc do
			local dm=tc:GetLevel()
			local dm2=tc:GetRank()
			if tc:IsLocation(LOCATION_GRAVE) then
				Duel.Hint(HINT_CARD,0,60158824)
				local g=Duel.GetLP(1-tp)
				Duel.SetLP(1-tp,g-(dm+dm2)*150)
			else
				Duel.Hint(HINT_CARD,0,60158824)
				local g=Duel.GetLP(1-tp)
				Duel.SetLP(1-tp,g-(dm+dm2)*300)
			end
			tc=ct:GetNext()
		end
	end
end
function c60158824.acopfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(1-tp)
end
function c60158824.acop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:Filter(c60158824.acopfilter2,nil,tp)
	if ct:GetCount()>0 then
		local tc=ct:GetFirst()
		while tc do
			local dm=tc:GetLevel()
			local dm2=tc:GetRank()
			Duel.Hint(HINT_CARD,0,60158824)
			local g=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,g-(dm+dm2)*150)
			tc=ct:GetNext()
		end
	end
end
function c60158824.cfilter(c)
	return c:IsSetCard(0x5b28) and c:GetBaseAttack()>0 and c:IsAbleToGraveAsCost()
end
function c60158824.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158824.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) 
		and e:GetHandler():GetFlagEffect(60158824)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60158824.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,99,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetChainLimit(c60158824.chlimit)
	local sum=0
	local tc=g:GetFirst()
	while tc do
		local atk=tc:GetBaseAttack()
		sum=sum+atk
		tc=g:GetNext()
	end
	e:SetLabel(sum)
end
function c60158824.chlimit(e,ep,tp)
	return tp==ep
end
function c60158824.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c60158824.efilter)
		e1:SetOwnerPlayer(tp)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(e:GetLabel())
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158824,0))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158824,1))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158824,2))
end
function c60158824.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
