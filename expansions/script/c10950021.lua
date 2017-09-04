--现世的指引者 樱
function c10950021.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10950021.spcon)
	e0:SetOperation(c10950021.spop2)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10950021,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c10950021.tg)
	e4:SetOperation(c10950021.op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetTargetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_DECK,0)
	e5:SetValue(c10950021.efilter) 
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(c10950021.efilter2) 
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10950021,0))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(c10950021.addct)
	e7:SetOperation(c10950021.addc)
	c:RegisterEffect(e7)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
end
function c10950021.spfilter(c)
	return c:IsSetCard(0x231) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function c10950021.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x231)
end
function c10950021.syc(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,23,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x13ac,23,REASON_COST)
end
function c10950021.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()   
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 
	and Duel.IsExistingMatchingCard(c10950021.spfilter2,tp,LOCATION_MZONE,0,2,nil) then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,23,REASON_COST) and Duel.IsExistingMatchingCard(c10950021.spfilter,c:GetControler(),LOCATION_MZONE,0,2,nil) 
end
end
function c10950021.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10950021.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.RemoveCounter(tp,1,0,0x13ac,23,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST) 
end
function c10950021.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x13ac)
end
function c10950021.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x13ac,18)
	end
end
function c10950021.filter(c)
	return c:IsAbleToHand()
end
function c10950021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10950021.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10950021.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10950021.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10950021.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and e:GetOwnerPlayer()~=te:GetOwnerPlayer() 
end
function c10950021.efilter2(e,te)
	return te:IsActiveType(TYPE_SPELL) and e:GetOwnerPlayer()~=te:GetOwnerPlayer() 
end