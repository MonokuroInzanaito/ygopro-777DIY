--河童「延展手臂」
function c23307008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23307008,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23307008)
	e1:SetTarget(c23307008.target)
	e1:SetOperation(c23307008.activate)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23307008,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,23307008)
	e3:SetCondition(c23307008.con2)
	e3:SetTarget(c23307008.target2)
	e3:SetOperation(c23307008.operation2)
	c:RegisterEffect(e3)
	if not NitoriGlobal then
		NitoriGlobal={}
		NitoriGlobal["Effects"]={}
	end
	NitoriGlobal["Effects"]["c23307008"]=e3
end
function c23307008.filter1(c)
	return c:IsSetCard(0x998) and c:IsDiscardable()
end
function c23307008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsExistingMatchingCard(c23307008.filter1,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,3,tp,LOCATION_DECK)
end
function c23307008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=Duel.SelectMatchingCard(tp,c23307008.filter1,tp,LOCATION_HAND,0,2,2,nil)
	if g1:GetCount()==2 then
		Duel.SendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
function c23307008.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(20500121)==0
end
function c23307008.filter2(c)
	return c:IsSetCard(0x998) and c:IsType(TYPE_SPELL) and not c:IsCode(23307008) and c:IsAbleToHand()
end
function c23307008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23307008.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	e:GetHandler():RegisterFlagEffect(20500121,RESET_EVENT+0x1680000,EFFECT_FLAG_COPY_INHERIT,1)
end
function c23307008.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c23307008.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c23307008.discon)
		e1:SetOperation(c23307008.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c23307008.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
end
function c23307008.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
end