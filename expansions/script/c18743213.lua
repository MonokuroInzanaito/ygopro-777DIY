--高达X
function c18743213.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44928016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,18743213)
	e1:SetCost(c18743213.cost)
	e1:SetTarget(c18743213.target)
	e1:SetOperation(c18743213.operation)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(96235275,0))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c18743213.discon)
	e2:SetTarget(c18743213.distg)
	e2:SetOperation(c18743213.disop)
	c:RegisterEffect(e2)
end
os=require("os")
function c18743213.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c18743213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c18743213.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18743213.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c18743213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18743214,0,0x4011,1000,1000,1,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c18743213.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18743214,0,0x4011,1000,1000,1,RACE_MACHINE,ATTRIBUTE_LIGHT) then
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+e:GetHandler():GetFieldID())
	local val=(math.random(0,5))
	Duel.SelectOption(tp,aux.Stringid(18743213,val))
		for i=1,2 do
			local token=Duel.CreateToken(tp,18743213+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
end
function c18743213.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c18743213.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return true end
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+e:GetHandler():GetFieldID())
	local val=(math.random(7,12))
	Duel.SelectOption(tp,aux.Stringid(18743213,val))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18743213.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then

		local g1=Duel.GetMatchingGroup(c18743213.ctfilter,tp,LOCATION_ONFIELD,0,nil)
		local ct=g1:FilterCount(c18743213.ctfilter,nil,nil)
		local g=Duel.GetMatchingGroup(c18743213.filter,tp,0,LOCATION_ONFIELD,nil)
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+e:GetHandler():GetFieldID())
	local val=(math.random(13,15))
	Duel.SelectOption(tp,aux.Stringid(18743213,val))
		if g:GetCount()>0 and ct>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c18743213.filter(c)
	return c:IsDestructable()
end
function c18743213.ctfilter(c)
	return c:IsCode(18743214) or c:IsCode(18743215)
end