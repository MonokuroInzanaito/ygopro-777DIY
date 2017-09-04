--扑克魔术 巧克力
function c66612301.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c66612301.pucon)
	e1:SetCost(c66612301.cost)
	e1:SetOperation(c66612301.operation)
	c:RegisterEffect(e1)
	--[[if not c66612301.global_check then
		c66612301.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c66612301.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c66612301.clear)
		Duel.RegisterEffect(ge2,0)
	end--]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66612301,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c66612301.thcon)
	e2:SetTarget(c66612301.thtg)
	e2:SetOperation(c66612301.thop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c66612301.setg)
	e3:SetOperation(c66612301.seop)
	c:RegisterEffect(e3)
end
function c66612301.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x660) then
			c66612301[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c66612301.clear(e,tp,eg,ep,ev,re,r,rp)
	c66612301[0]=true
	c66612301[1]=true
end
function c66612301.pucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c66612301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and  Duel.GetFlagEffect(tp,66612301)==0 end
	Duel.RegisterFlagEffect(tp,66612301,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c66612301.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,66612364)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c66612301.drcon)
	e1:SetOperation(c66612301.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c66612301.drfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c66612301.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66612301.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66612301.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroupCount(c66612301.drfilter,tp,LOCATION_MZONE,0,nil)
	if tg>0 and  Duel.IsPlayerCanDraw(tp,tg) and Duel.SelectYesNo(tp,aux.Stringid(66612301,0)) then
	Duel.Hint(HINT_CARD,0,66612301)
	if Duel.Draw(tp,tg,REASON_EFFECT)>0 and Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)>tg then
	local gc=Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsDiscardable,gc-tg,gc-tg,REASON_EFFECT+REASON_DISCARD,nil)	
	end
	end
end
function c66612301.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND)
end
function c66612301.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66612301.tgfilter,1,nil,tp)
end
function c66612301.thfilter(c)
	return c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c66612301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612301.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66612301.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c66612301.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c66612301.sefilter(c)
	return c:GetCode()==66612315 and c:IsAbleToHand()
end
function c66612301.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612301.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c66612301.seop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c66612301.sefilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end