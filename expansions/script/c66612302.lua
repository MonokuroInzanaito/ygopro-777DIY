--扑克魔术 薄荷茶
function c66612302.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c66612302.pucon)
	e1:SetCost(c66612302.cost)
	e1:SetOperation(c66612302.operation)
	c:RegisterEffect(e1)
	--[[if not c66612302.global_check then
		c66612302.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c66612302.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c66612302.clear)
		Duel.RegisterEffect(ge2,0)
	end--]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66612302,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c66612302.spcon)
	e2:SetTarget(c66612302.sptg)
	e2:SetOperation(c66612302.spop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c66612302.setg)
	e3:SetOperation(c66612302.seop)
	c:RegisterEffect(e3)
end
function c66612302.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x660) then
			c66612302[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c66612302.clear(e,tp,eg,ep,ev,re,r,rp)
	c66612302[0]=true
	c66612302[1]=true
end
function c66612302.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x660)
end
function c66612302.pucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c66612302.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and  Duel.GetFlagEffect(tp,66612301)==0 end
	Duel.RegisterFlagEffect(tp,66612301,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e:GetHandler():RegisterEffect(e1)
end
function c66612302.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,66612361)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c66612302.con)
	e1:SetOperation(c66612302.op)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c66612302.filter(c,tp)
	return c:IsSetCard(0x660) and c:IsControler(tp) and  c:IsType(TYPE_FUSION) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66612302.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66612302.filter,1,nil,tp)
end
function c66612302.gvfilter(c)
	return c:IsSetCard(0x660) and c:IsLevelBelow(4) and  c:IsAbleToHand()
end
function c66612302.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c66612302.gvfilter,tp,LOCATION_REMOVED,0,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(66612302,0)) then
	Duel.Hint(HINT_CARD,0,66612302)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c66612302.gvfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
end
function c66612302.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c66612302.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66612302.tgfilter,1,nil,tp)
end
function c66612302.spfilter(c,e,tp)
	return c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c66612302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612302.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c66612302.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c66612302.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c66612302.sefilter(c)
	return c:GetCode()==66612316 and c:IsAbleToHand()
end
function c66612302.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612302.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c66612302.seop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c66612302.sefilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
