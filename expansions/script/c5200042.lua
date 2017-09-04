--鲜血之结末
function c5200042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c5200042.cost)
	e1:SetTarget(c5200042.target)
	e1:SetOperation(c5200042.activate)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(5200042,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,5200042+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c5200042.thcon)
	e2:SetCost(c5200042.thcost)
	e2:SetTarget(c5200042.target)
	e2:SetOperation(c5200042.activate)
	c:RegisterEffect(e2)
end
function c5200042.cfilter(c)
	return c:IsSetCard(0x361) and c:IsAbleToGraveAsCost()
end
function c5200042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200042.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c5200042.cfilter,2,2,REASON_COST)
end
function c5200042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c5200042.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,2)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c5200042.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=2000
end
function c5200042.thfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x361) and c:IsAbleToRemoveAsCost()
end
function c5200042.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200042.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5200042.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end 