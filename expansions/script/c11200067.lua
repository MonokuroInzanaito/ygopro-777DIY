--兔符[因幡的白兔]
function c11200067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200067,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11200067)
	e2:SetTarget(c11200067.tdtg)
	e2:SetOperation(c11200067.tdop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetDescription(aux.Stringid(11200067,1))
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DRAW)
	e3:SetCondition(c11200067.condition)
	e3:SetOperation(c11200067.operation)
	c:RegisterEffect(e3)
	--upupupupupupupup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11200067,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,11200167)
	e4:SetCost(c11200067.upcost)
	e4:SetTarget(c11200067.uptg)
	e4:SetOperation(c11200067.upop)
	c:RegisterEffect(e4)
end
function c11200067.upcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11200067.uptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xffee) end
end
function c11200067.upop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0xffee)
	local tc=g:GetFirst()
	if tc then
	   Duel.ShuffleDeck(tp)
	   Duel.MoveSequence(tc,0)
	   Duel.ConfirmDecktop(tp,1)
	end
end
function c11200067.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c11200067.adfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_BEAST)
end
function c11200067.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200067.adfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(400)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)   
		tc:RegisterEffect(e2)   
		tc=g:GetNext()
	end
end
function c11200067.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,0)
end
function c11200067.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,e:GetHandler())
	if g:GetCount()==2 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	   local cg=Duel.GetOperatedGroup()
	   if cg:GetCount()==2 and cg:IsExists(Card.IsSetCard,2,nil,0xffee) then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_DRAW_COUNT)
		  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		  e1:SetReset(RESET_PHASE+PHASE_END,3)
		  e1:SetTargetRange(1,0)
		  e1:SetValue(2)
		  Duel.RegisterEffect(e1,tp)
	   end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	   if dg:GetCount()>0 then
		  Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	   end
	end
end