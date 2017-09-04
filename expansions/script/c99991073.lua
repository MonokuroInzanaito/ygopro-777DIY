--传说之暗杀者 两仪式
function c99991073.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c99991073.condition)
	e1:SetOperation(c99991073.desop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c99991073.tgcon)
	e2:SetValue(c99991073.tgvalue)
	c:RegisterEffect(e2)
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c99991073.rlevel)
	c:RegisterEffect(e3)
end
function c99991073.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xab23) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c99991073.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c99991073.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		if c:GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
			Duel.Hint(HINT_CARD,0,99991073)
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			local atk=c:GetAttack()
			local atk1=tc:GetAttack()
			local def1=tc:GetDefense()
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
				Duel.Hint(HINT_CARD,0,99991073)
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
end
function c99991073.tgcon(e)
	return  Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c99991073.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer() and  re:IsActiveType(TYPE_MONSTER)
end