--荣光的凯歌
function c60158835.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c60158835.ccon)
	c:RegisterEffect(e2)
	--30459350 chk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(30459350)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c60158835.ccon)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60158835,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,60158835)
	e4:SetCondition(c60158835.dcon)
	e4:SetOperation(c60158835.dop)
	c:RegisterEffect(e4)
	if c60158835.counter==nil then
		c60158835.counter=true
		c60158835[0]=0
		c60158835[1]=0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(c60158835.resetcount)
		Duel.RegisterEffect(e5,0)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_TO_GRAVE)
		e6:SetOperation(c60158835.addcount)
		Duel.RegisterEffect(e6,0)
	end
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(60158835,1))
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,6018835)
	e7:SetCondition(c60158835.con)
	e7:SetCost(c60158835.cost)
	e7:SetOperation(c60158835.op)
	c:RegisterEffect(e7)
end
function c60158835.ccon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c60158835.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c60158835.dop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct>3 then return end
	if (c60158835[tp])>(4-ct) then
		Duel.Draw(tp,(4-ct),REASON_EFFECT)
	else
		Duel.Draw(tp,c60158835[tp],REASON_EFFECT)
	end
end
function c60158835.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c60158835[0]=0
	c60158835[1]=0
end
function c60158835.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_COST) and re:IsHasType(0x7f0) and tc:IsSetCard(0x5b28) then
			local p=tc:GetReasonPlayer()
			c60158835[p]=c60158835[p]+1
		end
		tc=eg:GetNext()
	end
end
function c60158835.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
end
function c60158835.cffilter(c)
	return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c60158835.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158835.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c60158835.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c60158835.zfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c60158835.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c60158835.zfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
