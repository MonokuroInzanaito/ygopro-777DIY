--轨迹-诺艾尔
function c23303005.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c23303005.thcon)
	e1:SetTarget(c23303005.thtg)
	e1:SetOperation(c23303005.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c23303005.drcon)
	e2:SetCost(c23303005.drcost)
	e2:SetTarget(c23303005.drtg)
	e2:SetOperation(c23303005.drop)
	c:RegisterEffect(e2)
end
function c23303005.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x994) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c23303005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c23303005.tgfilter,1,nil,tp)
end
function c23303005.filter(c)
	return c:IsSetCard(0x994) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c23303005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23303005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23303005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23303005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c23303005.drfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x993)
end
function c23303005.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c23303005.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c23303005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x994) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c23303005.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c23303005.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c23303005.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c23303005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23303005.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
