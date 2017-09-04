--河中的便利屋-河城荷取
function c23307002.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23307002,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,23307002)
	e1:SetTarget(c23307002.target1)
	e1:SetOperation(c23307002.operation1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23307002,1))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,23307002)
	e3:SetCondition(c23307002.con2)
	e3:SetTarget(c23307002.target2)
	e3:SetOperation(c23307002.operation2)
	c:RegisterEffect(e3)
	if not NitoriGlobal then
		NitoriGlobal={}
		NitoriGlobal["Effects"]={}
	end
	NitoriGlobal["Effects"]["c23307002"]=e3
end
function c23307002.filter1(c)
	return c:IsSetCard(0x998) and not c:IsCode(23307002) and c:IsAbleToHand()
end
function c23307002.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23307002.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c23307002.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c23307002.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c23307002.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(20500031)==0
end
function c23307002.filter2(c)
	return c:IsSetCard(0x998) and not c:IsCode(23307002) and c:IsDiscardable()
end
function c23307002.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c23307002.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(20500031,RESET_EVENT+0x1680000,EFFECT_FLAG_COPY_INHERIT,1)
end
function c23307002.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=Duel.SelectMatchingCard(tp,c23307002.filter2,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end