--艺形魔-纸昆丁虎
function c21520187.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(c21520187.splimit)
	c:RegisterEffect(pe1)
	--to hand
	local pe2=Effect.CreateEffect(c)
	pe2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	pe2:SetDescription(aux.Stringid(21520187,0))
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1)
	pe2:SetCost(c21520187.thcost)
	pe2:SetTarget(c21520187.thtg)
	pe2:SetOperation(c21520187.thop)
	c:RegisterEffect(pe2)
	--silence
	local pe3=Effect.CreateEffect(c)
	pe3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	pe3:SetRange(LOCATION_PZONE)
	pe3:SetCode(EVENT_ATTACK_ANNOUNCE)
	pe3:SetCondition(c21520187.actcon)
	pe3:SetOperation(c21520187.actop)
	c:RegisterEffect(pe3)
	local pe4=pe3:Clone()
	pe4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(pe4)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(21520187,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c21520187.thcost2)
	e1:SetTarget(c21520187.thtg2)
	e1:SetOperation(c21520187.thop2)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520187,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520187)
	e2:SetTarget(c21520187.searchtg)
	e2:SetOperation(c21520187.searchop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c21520187.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x490) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c21520187.cfilter(c)
	return c:IsSetCard(0x490) and not c:IsPublic()
end
function c21520187.thfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToHand()
end
function c21520187.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520187.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c21520187.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
end
function c21520187.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520187.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520187.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsOnField() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c21520187.thfilter,tp,LOCATION_DECK,0,2,2,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPPO)
		local thg=g:Select(1-tp,1,1,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		Duel.ShuffleDeck(tp)
	end
end
function c21520187.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0x490)
end
function c21520187.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c21520187.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c21520187.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c21520187.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c21520187.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520187.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520187.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520187.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)
	local tc=thg:GetFirst()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c21520187.bantg)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(21520187,3)) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then 
		Duel.BreakEffect()
		local ttg=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Select(tp,1,1,nil)
		Duel.ShuffleDeck(tp)
--		Duel.DisableShuffleCheck()
		Duel.MoveSequence(ttg:GetFirst(),0)
	end
end
function c21520187.bantg(e,c)
	return c==e:GetLabelObject()
end
function c21520187.shfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand() and c:GetCode()~=21520187
end
function c21520187.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520187.shfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21520187.searchop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520187.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
end
