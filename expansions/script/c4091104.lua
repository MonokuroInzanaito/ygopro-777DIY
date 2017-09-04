--姬巫女-艾莉丝
function c4091104.initial_effect(c)
		--Pendulum
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,4091104)
	e2:SetHintTiming(TIMING_BATTLE_START)
	e2:SetCondition(c4091104.pencon)
	e2:SetTarget(c4091104.pentg)
	e2:SetOperation(c4091104.penop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4091104,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c4091104.damcost)
	e3:SetTarget(c4091104.sptg)
	e3:SetOperation(c4091104.spop)
	c:RegisterEffect(e3)
end
function c4091104.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,4091104)==0 end
	Duel.RegisterFlagEffect(tp,4091104,RESET_PHASE+PHASE_END,0,1)
end
function c4091104.pencon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local sc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return sc and sc:IsSetCard(0x42d) and  Duel.GetCurrentPhase()==PHASE_BATTLE 
end
function c4091104.penfilter(c)
	return c:IsSetCard(0x42d) and c:IsType(TYPE_PENDULUM) and not c:IsCode(4091104) and not c:IsForbidden()
end
function c4091104.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c4091104.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c4091104.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c4091104.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c4091104.filter(c)
	return c:IsSetCard(0x42d) and c:IsAbleToHand() and  (c:GetSequence()==6 or c:GetSequence()==7) 
end
function c4091104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4091104.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
end
function c4091104.filter2(c)
	return  c:IsSetCard(0x42d) and c:IsAbleToHand() and not c:IsForbidden()
end
function c4091104.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4091104.filter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local tp=e:GetHandlerPlayer()
	if Duel.IsExistingMatchingCard(c4091104.filter2,tp,LOCATION_GRAVE,0,1,nil,tp) then
	if Duel.SelectYesNo(tp,aux.Stringid(4091104,1)) then
	local g=Duel.SelectMatchingCard(tp,c4091104.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.BreakEffect()
	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
end
end
end