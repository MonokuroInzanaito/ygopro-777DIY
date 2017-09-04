--双子蝴蝶
function c10981090.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10981090,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(2,10981090)
	e1:SetCondition(c10981090.spcon)
	e1:SetTarget(c10981090.thtg)
	e1:SetOperation(c10981090.thop)
	c:RegisterEffect(e1)	
end
function c10981090.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c10981090.filter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function c10981090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10981090.thop(e,tp,eg,ep,ev,re,r,rp)	
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10981090.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and sg:GetClassCount(Card.GetCode)==sg:GetCount() then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
