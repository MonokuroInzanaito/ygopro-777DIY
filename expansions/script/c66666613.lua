--群星的洋馆
function c66666613.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c66666613.tg)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c66666613.tg2)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c66666613.condition)
	e3:SetTarget(c66666613.target)
	e3:SetOperation(c66666613.activate)
	c:RegisterEffect(e3)
	if not c66666613.global_check then
		c66666613.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetCondition(c66666613.regcon)
		ge1:SetOperation(c66666613.regop)
		Duel.RegisterEffect(ge1,0)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c66666613.negcost)
	e4:SetTarget(c66666613.negtg)
	e4:SetOperation(c66666613.negop)
	c:RegisterEffect(e4)
end
function c66666613.tg(e,c)
	return c:IsSetCard(0x661) and c:IsAttackPos()
end
function c66666613.tg2(e,c)
	return c:IsSetCard(0x661) and c:IsDefensePos()
end
function c66666613.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x661)
end
function c66666613.regcon(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c66666613.cfilter,1,nil,0) then
		sf=sf+1
	end
	if eg:IsExists(c66666613.cfilter,1,nil,1) then
		sf=sf+2
	end
	e:SetLabel(sf)
	return sf~=0
end
function c66666613.regop(e,tp,eg,ep,ev,re,r,rp)
	local sf=e:GetLabel()
	if bit.band(sf,1)~=0 then
		Duel.RegisterFlagEffect(0,66666613,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(sf,2)~=0 then
		Duel.RegisterFlagEffect(1,66666613,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c66666613.filter(c)
	return c:IsSetCard(0x661) and c:IsAbleToHand()
end
function c66666613.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,66666613)>0 and (Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingMatchingCard(c66666613.filter,tp,LOCATION_REMOVED,0,1,nil)) and Duel.GetTurnPlayer()==tp
end
function c66666613.exfilter(c)
	return c:IsSetCard(0x664) and c:IsFaceup()
end
function c66666613.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c66666613.filter(chkc)
		else return false end
	end
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c66666613.filter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(c66666613.exfilter,tp,LOCATION_MZONE,0,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(66666613,0),aux.Stringid(66666613,1),aux.Stringid(66666613,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(66666613,0),aux.Stringid(66666613,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(66666613,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(66666613,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
	end
end
function c66666613.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	if op~=1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c66666613.filter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c66666613.negcostfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x661) and c:IsAbleToGraveAsCost()
end
function c66666613.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c66666613.negcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c66666613.negcostfilter,1,1,REASON_COST)
end
function c66666613.negfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c66666613.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c66666613.negfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c66666613.negfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66666613.negfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c66666613.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
