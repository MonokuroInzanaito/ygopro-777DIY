--几何空间
function c21520181.initial_effect(c)
	--active
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520181,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,21520181)
	e2:SetCondition(c21520181.thcon)
	e2:SetTarget(c21520181.thtg)
	e2:SetOperation(c21520181.thop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520181,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21520181)
	e3:SetCondition(c21520181.drcon)
	e3:SetTarget(c21520181.drtg)
	e3:SetOperation(c21520181.drop)
	c:RegisterEffect(e3)
end
function c21520181.confilter(c,tp)
	return c:IsSetCard(0x490) and c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_MZONE
end
function c21520181.thfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToHand()
end
function c21520181.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520181.confilter,1,nil,tp)
end
function c21520181.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520181.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520181.thop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsOnField() and e:GetHandler():IsFaceup()) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520181.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21520181.drfilter(c,tp)
	return c:IsSetCard(0x490) and c:IsControler(tp) and ((c:IsPreviousPosition(POS_FACEUP_ATTACK) and c:IsPosition(POS_FACEUP_DEFENSE)) 
		or (c:IsPreviousPosition(POS_FACEUP_DEFENSE) and c:IsPosition(POS_FACEUP_ATTACK)))
end
function c21520181.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520181.drfilter,1,nil,tp)
end
function c21520181.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW+CATEGORY_TODECK,nil,0,tp,0)
end
function c21520181.dfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup()
end
function c21520181.drop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsOnField() and e:GetHandler():IsFaceup()) then return end
	local ct=Duel.GetMatchingGroupCount(c21520181.dfilter,tp,LOCATION_MZONE,0,nil)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dc<ct then return end
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.BreakEffect()
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,ct,ct,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
end
