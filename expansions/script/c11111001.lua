--魔王的转变
function c11111001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111001+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11111001.cost)
	e1:SetTarget(c11111001.target)
	e1:SetOperation(c11111001.activate)
	c:RegisterEffect(e1)
	 if not c11111001.global_check then
        c11111001.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c11111001.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c11111001.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local p1=false
    local p2=false
    while tc do
        if not tc:IsSetCard(0x15d) then
            if tc:GetSummonPlayer()==0 then p1=true else p2=true end
        end
        tc=eg:GetNext()
    end
    if p1 then Duel.RegisterFlagEffect(0,11111001,RESET_PHASE+PHASE_END,0,1) end
    if p2 then Duel.RegisterFlagEffect(1,11111001,RESET_PHASE+PHASE_END,0,1) end
end
function c11111001.rtfilter(c)
	return c:IsSetCard(0x15d) and c:IsType(TYPE_XYZ) and c:IsAbleToExtraAsCost()
end
function c11111001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11111001)==0
	    and Duel.IsExistingMatchingCard(c11111001.rtfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c11111001.rtfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c11111001.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c11111001.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x15d)
end
function c11111001.filter(c)
	return c:IsSetCard(0x15d) and c:IsAbleToHand()
end
function c11111001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c11111001.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
		    and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	end
end
function c11111001.activate(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) then return end
	local g=Duel.GetMatchingGroup(c11111001.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg1:RemoveCard(tc)
		end
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end