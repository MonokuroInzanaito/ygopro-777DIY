--哲尔 少女
function c60159002.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60159002)
	e1:SetCondition(c60159002.condition2)
	e1:SetCost(c60159002.negcost)
	e1:SetTarget(c60159002.target2)
	e1:SetOperation(c60159002.activate2)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159002,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60159002)
	e2:SetCondition(c60159002.negcon)
	e2:SetCost(c60159002.negcost)
	e2:SetTarget(c60159002.negtg)
	e2:SetOperation(c60159002.negop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159002,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,60159002)
	e3:SetTarget(c60159002.tgtg)
	e3:SetOperation(c60159002.tgop)
	c:RegisterEffect(e3)
end
function c60159002.negfilter(c,tp)
	return c:IsFaceup() and (((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) 
		and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)))
		and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c60159002.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c60159002.negfilter,1,nil,tp) and rp~=e:GetHandlerPlayer() and Duel.IsChainNegatable(ev)
end
function c60159002.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c60159002.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60159002.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c60159002.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and ((tc:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or t(c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) 
		and (tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_FUSION) or tc:IsType(TYPE_XYZ)))
end
function c60159002.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60159002.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c60159002.tgfilter(c)
	return c:IsSetCard(0xcb24) and c:IsAbleToHand()
end
function c60159002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60159002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end