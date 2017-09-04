--传说之枪兵 蕾米莉亚
function c99998941.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c99998941.ovfilter,aux.Stringid(99998941,2),3,c99998941.xyzop)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9999109,7))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c99998941.setg)
	e1:SetOperation(c99998941.seop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998941,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c99998941.mttg)
	e2:SetOperation(c99998941.mtop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c99998941.negcon)
	e3:SetOperation(c99998941.negop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
    e4:SetCondition(c99998941.negcon)
	e4:SetOperation(c99998941.negop2)
	c:RegisterEffect(e4)
end
function c99998941.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32e0)
end
function c99998941.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99998941)==0 end
	Duel.RegisterFlagEffect(tp,99998941,RESET_PHASE+PHASE_END,0,1)
end
function c99998941.filter(c)
	local code=c:GetCode()
	return (code==99998939) 
end
function c99998941.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998941.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99998941.ffilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsCode(99998940)
end
function c99998941.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99998941.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Equip(tp,tc,c)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	   if  e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and   Duel.IsExistingMatchingCard(c99998941.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	   and Duel.SelectYesNo(tp,aux.Stringid(99998941,0))  then
	   e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	  local tg=Duel.SelectMatchingCard(tp,c99998941.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	  if tg then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
end
end
end
function c99998941.mtfilter(c)
	return c:IsType(TYPE_SPELL)
end
function c99998941.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998941.mtfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c99998941.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c99998941.mtfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c99998941.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 
end
function c99998941.negop1(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d~=nil then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e2)
	end
end
function c99998941.negop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		a:RegisterEffect(e2)
end
