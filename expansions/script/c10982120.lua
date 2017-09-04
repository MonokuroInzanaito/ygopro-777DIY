--梦醒的少女·高岛柘榴
function c10982120.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10982120.ffilter1,c10982120.ffilter2,true) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10982120,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10982120)
	e1:SetTarget(c10982120.target)
	e1:SetOperation(c10982120.operation)
	c:RegisterEffect(e1)   
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10982120,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10982120.descon)
	e4:SetTarget(c10982120.destg)
	e4:SetOperation(c10982120.desop)
	c:RegisterEffect(e4)
end
function c10982120.ffilter1(c)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_SPIRIT)
end
function c10982120.ffilter2(c)
	return c:IsSetCard(0x4236) and not c:IsType(TYPE_SPIRIT)
end
function c10982120.filter(c)
	return c:IsSetCard(0x4236) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10982120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10982120.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10982120.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10982120.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10982120.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c10982120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10982120.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end