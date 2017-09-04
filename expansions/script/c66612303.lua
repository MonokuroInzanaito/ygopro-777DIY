--扑克魔术 麦芽糖
function c66612303.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66612303,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c66612303.pucon)
	e1:SetCost(c66612303.cost)
	e1:SetOperation(c66612303.operation)
	c:RegisterEffect(e1)
	--[[if not c66612303.global_check then
		c66612303.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c66612303.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c66612303.clear)
		Duel.RegisterEffect(ge2,0)
	end--]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66612303,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c66612303.drcon)
	e2:SetTarget(c66612303.drtg)
	e2:SetOperation(c66612303.drop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66612303,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c66612303.secost)
	e3:SetTarget(c66612303.setg)
	e3:SetOperation(c66612303.seop)
	c:RegisterEffect(e3)
end
function c66612303.clear(e,tp,eg,ep,ev,re,r,rp)
	c66612303[0]=true
	c66612303[1]=true
end
function c66612303.pucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c66612303.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and  Duel.GetFlagEffect(tp,66612301)==0 end
	Duel.RegisterFlagEffect(tp,66612301,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e:GetHandler():RegisterEffect(e1)
end
function c66612303.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,66612363)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c66612303.con)
	e1:SetOperation(c66612303.op)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c66612303.cfilter(c,tp)
	return c:IsSetCard(0x660) and c:IsControler(tp) and  c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c66612303.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66612303.cfilter,1,nil,tp) 
end
function c66612303.gvfilter(c)
	return c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66612303.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,66612303)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c66612303.refilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) 
end
function c66612303.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66612303.refilter,1,nil,tp)
end
function c66612303.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66612303.drop(e,tp,eg,ep,ev,re,r,rp)
  	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66612303.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost()  end
	Duel.SendtoGrave(c,REASON_COST)
end
function c66612303.sefilter(c)
	return c:GetCode()==66612317 and c:IsAbleToHand()
end
function c66612303.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612303.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c66612303.seop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c66612303.sefilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
