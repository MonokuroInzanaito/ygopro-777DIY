--黑圣女 和久津智
function c18738102.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	e1:SetCountLimit(1,187381020)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18738102.spcon)
	e1:SetOperation(c18738102.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4939890,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,18738102)
	e2:SetCondition(c18738102.thcon)
	e2:SetTarget(c18738102.drtg)
	e2:SetOperation(c18738102.drop)
	c:RegisterEffect(e2)
end
function c18738102.spfilter(c)
	return c:IsFaceup()
end
function c18738102.spcon(e,c)
	if c==nil then return true end
	if not e:GetHandler():IsHasEffect(18738107) then
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c18738102.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c18738102.rmfilter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),nil) 
	else
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c18738102.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c18738102.rmfilter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler(),nil) 
	end
end
function c18738102.ifilter(c)
	return c:IsFacedown()
end
function c18738102.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if not e:GetHandler():IsHasEffect(18738107) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738102.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18738102.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
	end
end
function c18738102.rmfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x3ab0) and c:IsType(TYPE_MONSTER)
end
function c18738102.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and (c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_DECK))
end
function c18738102.filter(c,e)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c18738102.filter1(c,e)
	return c:IsSetCard(0x3ab0) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c18738102.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c18738102.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738102.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e) and Duel.IsPlayerCanDraw(tp,1) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,c18738102.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e)
		g:Sub(g1)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c18738102.drop(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)>0 then 
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
end