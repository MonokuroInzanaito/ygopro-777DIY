--红色骑士团出发之日
function c60158837.initial_effect(c)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60158837)
    e1:SetCost(c60158837.cost)
    e1:SetTarget(c60158837.target)
    e1:SetOperation(c60158837.activate)
    c:RegisterEffect(e1)
end
function c60158837.cfilter(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER)
end
function c60158837.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158837.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c60158837.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c60158837.spfilter(c,e,tp)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158837.filter2(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60158837.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c60158837.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp))
	local b2=(Duel.IsExistingMatchingCard(c60158837.filter2,tp,LOCATION_DECK,0,1,nil))
    if chk==0 then return b1 or b2 end
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(60158837,0),aux.Stringid(60158837,1))
		if op==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		else
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		end
		e:SetLabel(op)
	elseif b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(60158837,0))
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		e:SetLabel(op)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(60158837,1))+1
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetLabel(op)
	end
end
function c60158837.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60158837.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60158837.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
    end
end