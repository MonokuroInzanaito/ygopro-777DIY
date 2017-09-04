--永夜骑士 断线人偶
function c99991086.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsSetCard,0x3ab0),1)
	c:EnableReviveLimit()
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99991086.efilter)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99991086,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,99991086)
	e2:SetCost(c99991086.cost)
	e2:SetTarget(c99991086.postg)
	e2:SetOperation(c99991086.posop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99991086,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,99991086)
	e3:SetCost(c99991086.cost)
	e3:SetCondition(c99991086.discon)
	e3:SetTarget(c99991086.distg)
	e3:SetOperation(c99991086.disop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c99991086.reptg)
	e4:SetValue(c99991086.repval)
	e4:SetOperation(c99991086.repop)
	c:RegisterEffect(e4)
end
function c99991086.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c99991086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99991086.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c99991086.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991086.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c99991086.posop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c99991086.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c99991086.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99991086.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991086.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99991086.filter(c)
	return c:GetCode()==18738107 and c:IsAbleToHand()
end
function c99991086.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99991086.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99991086.repfilter(c,tp)
	return  c:IsControler(tp) and ((c:IsFaceup() and ((c:IsSetCard(0x3ab0) and c:IsLocation(LOCATION_MZONE)) or c:IsCode(18738107))) or (c:IsFacedown() and c:IsLocation(LOCATION_MZONE)))
end
function c99991086.tgfilter(c)
	return c:IsSetCard(0x3ab0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c99991086.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c99991086.repfilter,1,nil,tp) 
	and Duel.IsExistingMatchingCard(c99991086.tgfilter,tp,LOCATION_DECK,0,1,nil)
	and e:GetHandler():GetFlagEffect(99991086)==0 end
	return Duel.SelectYesNo(tp,aux.Stringid(99991086,2))
end
function c99991086.repval(e,c)
	return c99991086.repfilter(c,e:GetHandlerPlayer())
end
function c99991086.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c99991086.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REPLACE)
	 e:GetHandler():RegisterFlagEffect(99991086,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
end