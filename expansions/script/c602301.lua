--星刻琉璃 特瓦耶摩尔
function c602301.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,602301)
	e1:SetOperation(c602301.activate)
	c:RegisterEffect(e1)
end

function c602301.filter(c)
	return c:IsSetCard(0x42c) and c:IsType(TYPE_MONSTER)
end

function c602301.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and not Duel.IsPlayerAffectedByEffect(tp,30459350) end
	local g=Duel.GetMatchingGroup(c602301.filter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(602301,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
			local dc=Duel.GetOperatedGroup():GetFirst()
			if dc:IsSetCard(0x42c) and dc:IsType(TYPE_TRAP) then
				Duel.ConfirmCards(1-tp,dc) 
				Duel.Draw(p,d,REASON_EFFECT)
			end
		end
	 end
end
