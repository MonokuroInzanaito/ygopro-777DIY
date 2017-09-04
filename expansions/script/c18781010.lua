--夜鴉
function c18781010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c18781010.splimcon)
	e2:SetTarget(c18781010.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70832512,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c18781010.condition)
	e1:SetTarget(c18781010.atktarget)
	e1:SetOperation(c18781010.atkoperation)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70832512,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c18781010.condition)
	e1:SetTarget(c18781010.atktarget)
	e1:SetOperation(c18781010.atkoperation)
	c:RegisterEffect(e1)
	--direct
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(31437713,0))
	--e4:SetType(EFFECT_TYPE_IGNITION)
	--e4:SetCountLimit(1,18781010)
	--e4:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	--e4:SetCost(c18781010.cost)
	--e4:SetTarget(c18781010.target)
	--e4:SetOperation(c18781010.operation)
	--c:RegisterEffect(e4)
end
function c18781010.ccfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6abb) and c:IsType(TYPE_XYZ)
end
function c18781010.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c18781010.splimit(e,c)
	return not c:IsSetCard(0xabb)
end
function c18781010.filter2(c,tp,e)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and (not e or c:IsRelateToEffect(e))
end
function c18781010.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c18781010.ccfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c18781010.atktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c18781010.filter2,1,nil,tp) end
	local g=eg:Filter(c18781010.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c18781010.atkoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(tp,c18781010.ccfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc2=g2:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc2,Group.FromCards(tc))
		Duel.Overlay(tc2,Group.FromCards(c))
	end
end
function c18781010.cfilter(c)
	return c:IsReleasable() and c:IsSetCard(0x3abb) and not c:IsCode(18781010)
end
function c18781010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c18781010.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectTarget(tp,c18781010.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c18781010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18781010.filter,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c18781010.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c18781010.filter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c18781010.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb) and c:IsAbleToHand()
end