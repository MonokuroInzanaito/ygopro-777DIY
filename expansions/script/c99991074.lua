--传说之剑士 两仪式
function c99991074.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99991074.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c99991074.condition)
	e2:SetOperation(c99991074.desop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99991074,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99991074.atkcon)
	e3:SetCost(c99991074.atkcost)
	e3:SetTarget(c99991074.atktg)
	e3:SetOperation(c99991074.atkop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c99991074.disop)
	c:RegisterEffect(e4)
end
function c99991074.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x2e0) or se:GetHandler():IsSetCard(0x2e1) or se:GetHandler():IsSetCard(0x2e7) or se:GetHandler():IsCode(60151299)
end
function c99991074.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c99991074.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		local atk=c:GetAttack()
		local atk1=tc:GetAttack()
		local def1=tc:GetDefense()
		if c:GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
			Duel.Hint(HINT_CARD,0,99991074)
			if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
				local atk2=tc:GetBaseAttack()
				if atk>atk2 then Duel.BreakEffect()
					Duel.Recover(tp,atk-atk2,REASON_EFFECT)
				end
				if atk2>atk then Duel.BreakEffect()
					Duel.Recover(tp,atk2-atk,REASON_EFFECT)
				end
			end
		else
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
				Duel.Hint(HINT_CARD,0,99991074)
				if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
					local atk2=tc:GetBaseAttack()
					if atk>atk2 then Duel.BreakEffect()
						Duel.Recover(tp,atk-atk2,REASON_EFFECT)
					end
					if atk2>atk then Duel.BreakEffect()
						Duel.Recover(tp,atk2-atk,REASON_EFFECT)
					end
				end
			end
		end
	end
end
function c99991074.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c99991074.costfilter(c)
	return  c:IsDiscardable()
end
function c99991074.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991074.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99991074.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c99991074.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c99991074.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c99991074.ftarget)
		e2:SetLabel(e:GetHandler():GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
end
function c99991074.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c99991074.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end