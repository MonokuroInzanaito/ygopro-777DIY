--灵使凭依
function c18706057.initial_effect(c)
	c:SetUniqueOnField(1,0,18706057)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18706057.target)
	e1:SetOperation(c18706057.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,18706057)
	e2:SetTarget(c18706057.sptg)
	e2:SetOperation(c18706057.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCountLimit(1,18706057)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c18706057.splimcon)
	e4:SetTarget(c18706057.splimit)
	c:RegisterEffect(e4)
end
function c18706057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local g=Duel.GetMatchingGroup(c18706057.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetAttribute)>=4
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18706057.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c18706057.thfilter,tp,LOCATION_DECK,0,nil)

	if g:GetCount()>=4 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsAttribute,nil,g1:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g2=g:Select(tp,1,1,nil)
	g:Remove(Card.IsAttribute,nil,g2:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g3=g:Select(tp,1,1,nil)
	g:Remove(Card.IsAttribute,nil,g3:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g4=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
		Duel.ConfirmCards(1-tp,g1)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=g1:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c18706057.thfilter(c)
	return c:IsSetCard(0xabb) and c:GetLevel()==4 and c:IsAbleToHand()
end
function c18706057.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c187081014.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18706057.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18706057.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18706057.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18706057.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xabb) and c:GetLevel()==4
end
function c18706057.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c18706057.splimit(e,c)
	return not c:IsSetCard(0xabb)
end