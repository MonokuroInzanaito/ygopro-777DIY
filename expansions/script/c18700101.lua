--圣殿骑士 人偶
function c18700101.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),aux.NonTuner(Card.IsSetCard,0xab0),1)
	c:EnableReviveLimit()
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18700101.efilter)
	c:RegisterEffect(e1)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13959634,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c18700101.discon)
	e3:SetTarget(c18700101.distg)
	e3:SetOperation(c18700101.disop)
	c:RegisterEffect(e3)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c18700101.reptg)
	e2:SetValue(c18700101.repval)
	e2:SetOperation(c18700101.repop)
	c:RegisterEffect(e2)
end
function c18700101.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c18700101.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c18700101.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18700101.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18700101.filter(c)
	return c:GetCode()==18799010 and c:IsAbleToHand()
end
function c18700101.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18700101.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18700101.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and ((c:IsSetCard(0xab0)and c:IsLocation(LOCATION_MZONE)) or c:IsCode(18799010))
end
function c18700101.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c18700101.repfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(18700101)==0 end
	return Duel.SelectYesNo(tp,aux.Stringid(18700101,1))
end
function c18700101.repval(e,c)
	return c18700101.repfilter(c,e:GetHandlerPlayer())
end
function c18700101.repop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.PayLPCost(tp,500)
	 e:GetHandler():RegisterFlagEffect(18700101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end