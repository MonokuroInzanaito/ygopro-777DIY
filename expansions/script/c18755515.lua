--操偶的猫女仆
function c18755515.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xabb),1)
	c:EnableReviveLimit()
	--targettoactiveremov
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(30303058,0))
	--e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
   -- e3:SetType(EFFECT_TYPE_QUICK_O)
   -- e3:SetCode(EVENT_BECOME_TARGET)
   -- e3:SetRange(LOCATION_MZONE)
	----e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
   -- e3:SetCondition(c18755515.spcon)
	--e3:SetTarget(c18755515.target)
   -- e3:SetOperation(c18755515.activate)
   -- c:RegisterEffect(e3) 
	--attacktoactiveremov
   --  local e4=Effect.CreateEffect(c)
   --  e4:SetDescription(aux.Stringid(30303058,0))
   --  e4:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	-- e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	-- e4:SetCode(EVENT_BE_BATTLE_TARGET)
	-- e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	-- e4:SetTarget(c18755515.target)
	-- e4:SetOperation(c18755515.activate)
	-- c:RegisterEffect(e4)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18755515,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c18755515.desreptg)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,18755515)
	e2:SetCondition(c18755515.con)
	e2:SetTarget(c18755515.thtg)
	e2:SetOperation(c18755515.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c18755515.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x5abb)
end
function c18755515.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18755515.cfilter,1,nil,tp)
end
function c18755515.thfilter(c)
	return c:IsSetCard(0x5abb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18755515.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18755515.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18755515.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18755515.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18755515.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c18755515.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18755515.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c18755515.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c18755515.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	if Duel.SelectYesNo(tp,aux.Stringid(18755515,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c18755515.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c18755515.filter(c)
	return c:IsSetCard(0x5abb)
end