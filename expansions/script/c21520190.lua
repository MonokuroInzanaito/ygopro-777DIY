--艺形魔-纸龙神
function c21520190.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local pe1=Effect.CreateEffect(c)
	pe1:SetCategory(CATEGORY_ATKCHANGE)
	pe1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	pe1:SetProperty(EFFECT_FLAG_DELAY)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCode(EVENT_SPSUMMON_SUCCESS)
	pe1:SetCondition(c21520190.atkcon)
	pe1:SetOperation(c21520190.atkop)
	c:RegisterEffect(pe1)
	--draw
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(21520190,0))
	pe2:SetCategory(CATEGORY_DRAW)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1)
	pe2:SetCondition(c21520190.drcon)
	pe2:SetTarget(c21520190.drtg)
	pe2:SetOperation(c21520190.drop)
	c:RegisterEffect(pe2)
	--to hand
	local pe3=Effect.CreateEffect(c)
	pe3:SetDescription(aux.Stringid(21520190,1))
	pe3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	pe3:SetType(EFFECT_TYPE_IGNITION)
	pe3:SetRange(LOCATION_PZONE)
	pe3:SetCountLimit(1)
	pe3:SetCondition(c21520190.thcon)
	pe3:SetTarget(c21520190.thtg)
	pe3:SetOperation(c21520190.thop)
	c:RegisterEffect(pe3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c21520190.spcon)
	c:RegisterEffect(e1)
	--another draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520190,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520190)
	e2:SetTarget(c21520190.dr2tg)
	e2:SetOperation(c21520190.dr2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--hand back to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520190,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,21520190)
	e4:SetCondition(c21520190.condition)
	e4:SetCost(c21520190.cost)
	e4:SetTarget(c21520190.target)
	e4:SetOperation(c21520190.operation)
	c:RegisterEffect(e4)
--[[
	--atk &def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c21520190.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE)
	e6:SetValue(c21520190.defval)
	c:RegisterEffect(e5)
--]]
end
function c21520190.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x490)
end
function c21520190.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520190.filter,1,nil) 
end
function c21520190.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if eg:IsExists(c21520190.filter,1,nil) then 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(200)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c21520190.drcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x490) and not tc:IsCode(21520190)
end
function c21520190.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(c21520190.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520190,0))
	local ct=Duel.GetMatchingGroupCount(c21520190.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c21520190.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDraw(tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ct=Duel.GetMatchingGroupCount(c21520190.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(c:GetControler(),ct,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Destroy(c,REASON_EFFECT)
end
function c21520190.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
end
function c21520190.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand()
--Group.CheckWithSumEqual(Group g, function f, int sum, int min, int max, ...)
end
function c21520190.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c21520190.thfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckWithSumEqual(Card.GetOriginalLevel,7,2,2) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520190,1))
	local c=e:GetHandler()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	local dg=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c21520190.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	local g=Duel.GetMatchingGroup(c21520190.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 or not g:CheckWithSumEqual(Card.GetOriginalLevel,7,2,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.GetMatchingGroup(c21520190.thfilter,tp,LOCATION_DECK,0,nil)
	local sg=g:SelectWithSumEqual(tp,Card.GetOriginalLevel,7,2,2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
end
function c21520190.spfilter(c)
	return c:IsSetCard(0x490) and (not c:IsOnField() or c:IsFaceup())
end
function c21520190.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c21520190.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,e:GetHandler())
	local ct=g:GetClassCount(Card.GetCode)
	return ct>5
end
function c21520190.dr2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp)
	end
	local ct=Duel.GetMatchingGroupCount(c21520190.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c21520190.dr2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetMatchingGroupCount(c21520190.filter,tp,LOCATION_MZONE,0,c)
	Duel.Draw(c:GetControler(),ct,REASON_EFFECT)
end
function c21520190.condition(e,tp,eg,ep,ev,re,r,rp)
	local sel=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local opp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return sel>opp and Duel.IsExistingMatchingCard(c21520190.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c21520190.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21520190.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sel=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local opp=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,sel+opp)
end
function c21520190.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--[[
function c21520190.adfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup() and not c:IsCode(21520190)
end
function c21520190.atkval(e,c)
	local g=Duel.GetMatchingGroup(c21520190.adfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetAttack()
		tc=g:GetNext()
	end
	return sum
end
function c21520190.defval(e,c)
	local g=Duel.GetMatchingGroup(c21520190.adfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetDefense()
		tc=g:GetNext()
	end
	return sum
end
--]]