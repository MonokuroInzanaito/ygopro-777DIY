--两仪式
function c18706066.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),10,3)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c18706066.condition)
	e1:SetOperation(c18706066.desop)
	c:RegisterEffect(e1)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54719828,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c18706066.cost)
	e1:SetTarget(c18706066.target)
	e1:SetOperation(c18706066.operation)
	c:RegisterEffect(e1)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c18706066.condition1)
	e1:SetValue(c18706066.aclimit1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c18706066.condition2)
	e1:SetValue(c18706066.aclimit2)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c18706066.condition3)
	e1:SetValue(c18706066.aclimit3)
	c:RegisterEffect(e1)
end
function c18706066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18706066.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c18706066.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
			local atk=c:GetAttack()
			local atk1=tc:GetAttack()
			local def1=tc:GetDefense()
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_CARD,0,18706066)
				Duel.SendtoGrave(tc,REASON_RULE)
			end
	end
end
function c18706066.thfilter(c)
	return c:IsCode(18706067) and c:IsAbleToGrave()
end
function c18706066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706066.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(18706066,1),aux.Stringid(18706066,2),aux.Stringid(18706066,3))
	e:SetLabel(op)
end
function c18706066.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetDescription(aux.Stringid(18706066,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e:GetHandler():RegisterEffect(e1)
			e:GetHandler():RegisterFlagEffect(187060661,RESET_EVENT+0x1fe0000,0,1)
	elseif e:GetLabel()==1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetDescription(aux.Stringid(18706066,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e:GetHandler():RegisterEffect(e1)
			e:GetHandler():RegisterFlagEffect(187060662,RESET_EVENT+0x1fe0000,0,1)
	else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetDescription(aux.Stringid(18706066,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e:GetHandler():RegisterEffect(e1)
			e:GetHandler():RegisterFlagEffect(187060663,RESET_EVENT+0x1fe0000,0,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18706066.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
			local ae=tc:GetActivateEffect()
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(ae:GetDescription())
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			e1:SetTarget(c18706066.spelltg)
			e1:SetOperation(c18706066.spellop)
			tc:RegisterEffect(e1)
end
function c18706066.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c18706066.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c18706066.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(187060661)>0 
end
function c18706066.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(187060662)>0 
end
function c18706066.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(187060663)>0 
end
function c18706066.aclimit1(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_HAND)
end
function c18706066.aclimit2(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c18706066.aclimit3(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_REMOVED)
end