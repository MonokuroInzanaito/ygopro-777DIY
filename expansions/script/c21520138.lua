--星辰齐出
function c21520138.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520138,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520138+EFFECT_COUNT_CODE_OATH)
--	e1:SetTarget(c21520138.target)
	e1:SetOperation(c21520138.activate)
	c:RegisterEffect(e1)
end
function c21520138.filter(c)
	return c:IsSetCard(0x491) and c:IsAbleToGrave()
end
function c21520138.thfilter(c)
	return (c:IsSetCard(0x491) or c:IsSetCard(0x492)) and c:IsAbleToHand()
end
function c21520138.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520138.filter,tp,LOCATION_DECK,0,nil)
	local ug=c21520138.group_unique_code(g)
	local count=7
	if ug:GetCount()<7 then count=ug:GetCount() end
	if ug:GetCount()==0 then
		local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
		Duel.Damage(tp,4000,REASON_RULE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=ug:Select(tp,1,count,nil)
		local ct=Duel.SendtoGrave(g1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		while ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 do
			Duel.ConfirmDecktop(tp,1)
			local hg=Duel.GetDecktopGroup(tp,1)
			local tc=hg:GetFirst()
			if c21520138.thfilter(tc) then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				ct=ct-1
			else
				ct=0
			end
		end
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
	end
end
function c21520138.group_unique_code(g)
	local check={}
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				tg:AddCard(tc)
			end
		end
		tc=g:GetNext()
	end
	return tg
end
