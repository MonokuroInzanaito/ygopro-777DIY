--黑之圣杯
function c99991085.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(99991085,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,99991085)
	e1:SetCost(c99991085.cost)
	e1:SetTarget(c99991085.tg1)
	e1:SetOperation(c99991085.op1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(99991096,13))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,99991085)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c99991085.cost)
	e2:SetTarget(c99991085.tg2)
	e2:SetOperation(c99991085.op2)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetDescription(aux.Stringid(99991085,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,99991085)
	e3:SetCost(c99991085.cost2)
	e3:SetTarget(c99991085.tg3)
	e3:SetOperation(c99991085.op3)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(99991085,ACTIVITY_SPSUMMON,c99991085.counterfilter)
	--cannot chain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetDescription(aux.Stringid(99991085,3))
	e4:SetCountLimit(1,99991085)
	e4:SetCost(c99991085.cost)
	e4:SetOperation(c99991085.op4)
	c:RegisterEffect(e4)
end
function c99991085.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
end
function c99991085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99991085.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99991085.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and  tc:IsType(TYPE_MONSTER) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	    local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	    e2:SetCode(EVENT_PHASE+PHASE_END)
	    e2:SetCountLimit(1)	   
	    e2:SetCondition(c99991085.lpcon)
	    e2:SetOperation(c99991085.lpcost)
	    Duel.RegisterEffect(e2,tp)
	    local e3=e2:Clone()
	    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e3,tp)
end
function c99991085.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler()  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99991085.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	end
	    local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	    e2:SetCode(EVENT_PHASE+PHASE_END)
	    e2:SetCountLimit(1)
	    e2:SetCondition(c99991085.lpcon)
	    e2:SetOperation(c99991085.lpcost)
	    Duel.RegisterEffect(e2,tp)
	    local e3=e2:Clone()
	    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e3,tp)
end
function c99991085.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetCustomActivityCount(99991085,tp,ACTIVITY_SPSUMMON)==0  end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99991085.sumlimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99991085.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return  not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY))
end
function c99991085.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY))
end
function c99991085.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991085.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99991085.op3(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	    local g=Duel.SelectMatchingCard(tp,c99991085.tgfilter,tp,LOCATION_DECK,0,1,1,nil) 
	    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and 
		Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) and 
		Duel.SelectYesNo(tp,aux.Stringid(99991085,4)) then
	    local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil) 
		if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	    end
		end
	    local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	    e2:SetCode(EVENT_PHASE+PHASE_END)
	    e2:SetCountLimit(1)
	    e2:SetCondition(c99991085.lpcon)
	    e2:SetOperation(c99991085.lpcost)
	    Duel.RegisterEffect(e2,tp)
	    local e3=e2:Clone()
	    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e3,tp)
end
function c99991085.op4(e,tp,eg,ep,ev,re,r,rp)
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetCondition(c99991085.chaincon)
		e1:SetOperation(c99991085.chainop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	    e2:SetCode(EVENT_PHASE+PHASE_END)
	    e2:SetCountLimit(1)	  
	    e2:SetCondition(c99991085.lpcon)
	    e2:SetOperation(c99991085.lpcost)
	    Duel.RegisterEffect(e2,tp)
	    local e3=e2:Clone()
	    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e3,tp)
end
function c99991085.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==tp
end
function c99991085.chainop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetChainLimit(c99991085.chainlm)
end
function c99991085.chainlm(e,rp,tp)
	return tp==rp
end	
function c99991085.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c99991085.lpcost(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,99991085)
	Duel.SetLP(tp,Duel.GetLP(tp)-500)
end
