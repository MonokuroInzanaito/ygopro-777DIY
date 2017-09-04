--亡灵的狩场
function c18740411.initial_effect(c)
	c:EnableCounterPermit(0x2f,LOCATION_SZONE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18740411,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c18740411.addcon)
	e2:SetTarget(c18740411.addct)
	e2:SetOperation(c18740411.addop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70791313,0))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,18740411)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCost(c18740411.drcost)
	e3:SetOperation(c18740411.drop)
	c:RegisterEffect(e3)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(22624373,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c18740411.target2)
	e2:SetOperation(c18740411.operation2)
	c:RegisterEffect(e2)
end
function c18740411.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp
end
function c18740411.addcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18740411.spfilter,1,nil,tp)
end
function c18740411.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x2f)
end
function c18740411.addop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c18740411.spfilter,nil,tp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x2f,ct)
	end
end
function c18740411.filter1(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToGrave()
end
function c18740411.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab5) and c:IsAbleToHand()
end
function c18740411.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelAbove(5) and c:IsSetCard(0xab5)
end
function c18740411.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x2f)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x2f,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x2f,ct,REASON_COST)
	e:SetLabel(ct)
end
function c18740411.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=e:GetLabel()
	g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(1-tp,g)
	local sg2=Duel.SelectMatchingCard(1-tp,c18740411.filter1,tp,0,LOCATION_DECK,ct,ct,nil)
	if sg2:GetCount()>0 then
	   if Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)>0 and sg2:GetCount()>4 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c18740411.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	end
	end
end
function c18740411.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18740411.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c18740411.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c18740411.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c18740411.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
