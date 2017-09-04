--操鸟师 黑鹳
function c18702325.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89258906,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,18702325)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c18702325.condition)
	e1:SetOperation(c18702325.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45286019,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,187023250)
	e1:SetCondition(c18702325.spcon)
	e1:SetTarget(c18702325.sptg)
	e1:SetOperation(c18702325.spop)
	c:RegisterEffect(e1)
end
function c18702325.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x6ab2)
end
function c18702325.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c18702325.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c18702325.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
function c18702325.filter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c18702325.filter1(c,e)
	return c:IsSetCard(0x6ab2) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c18702325.spcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+250) and st<(SUMMON_TYPE_SPECIAL+260)
end
function c18702325.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c18702325.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702325.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e)
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g1=Duel.SelectMatchingCard(tp,c18702325.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
		g:Sub(g1)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
			local g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
end
function c18702325.spop(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
		if not sg or sg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
end