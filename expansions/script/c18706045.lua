--鏖杀公 夜刀神十香
function c18706045.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,18706045)
	e3:SetCondition(c18706045.scon)
	e3:SetTarget(c18706045.stg)
	e3:SetOperation(c18706045.sop)
	c:RegisterEffect(e3)
	--level change
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_IGNITION)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetCountLimit(1)
	--e5:SetTarget(c18706045.lvtar)
	--e5:SetOperation(c18706045.lvop)
	--c:RegisterEffect(e5)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c18706045.efcon)
	e1:SetOperation(c18706045.efop)
	c:RegisterEffect(e1)
end
function c18706045.scon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c18706045.sfilter(c)
	return c:IsCode(18706056) and c:IsAbleToHand()
end
function c18706045.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and c18706045.sfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c18706045.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c18706045.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c18706045.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c18706045.lvfilter(c)
	return c:GetLevel()~=10 and c:IsSetCard(0xabb)
end
function c18706045.lvtar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706045.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c18706045.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18706045.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(10)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c18706045.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c18706045.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c18706045.aclimit)
	e2:SetCondition(c18706045.actcon)
	rc:RegisterEffect(e2)
end
function c18706045.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c18706045.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end