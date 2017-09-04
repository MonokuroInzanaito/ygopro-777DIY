--零之赠礼
function c10981047.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10981047.condition)
	e1:SetTarget(c10981047.remtg)
	e1:SetOperation(c10981047.remop)
	c:RegisterEffect(e1)	
end
function c10981047.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function c10981047.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)	
end
function c10981047.remop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
    if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) then
		local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_REMOVED,0,nil)
		if ct>5 then ct=5 end
		Duel.ConfirmDecktop(tp,ct)
		local cg=Duel.GetDecktopGroup(tp,ct)
		if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10981047,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10981047,1))
            local sg=cg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tc,1)
            Duel.Draw(tp,1,REASON_EFFECT)
            cg:Sub(sg)
			end
		else
		Duel.ShuffleDeck(tp)
		end
	end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
        e1:SetCountLimit(1)
        e1:SetLabel(c10981047.counter)
        e1:SetCondition(c10981047.retcon)
        e1:SetOperation(c10981047.retop)
        e1:SetLabelObject(g)
        Duel.RegisterEffect(e1,tp)
        g:KeepAlive()
        local tc=g:GetFirst()
        while tc do
            tc:RegisterFlagEffect(10981047,RESET_EVENT+0x1fe0000,0,1)
            tc=g:GetNext()
        end
    end
function c10981047.retfilter(c)
    return c:GetFlagEffect(10981047)~=0
end
function c10981047.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c10981047.retop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local sg=g:Filter(c10981047.retfilter,nil)
    g:DeleteGroup()
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end