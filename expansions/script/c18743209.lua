--飞翼高达零式
function c18743209.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18743209,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(c18743209.condition)
	e1:SetTarget(c18743209.target)
	e1:SetOperation(c18743209.operation)
	c:RegisterEffect(e1)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18743209,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c18743209.desreptg)
	c:RegisterEffect(e3)
	--targettoactiveremov
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(18743209,1))
	--e3:SetCategory(CATEGORY_POSITION)
	--e3:SetType(EFFECT_TYPE_QUICK_O)
	--e3:SetCode(EVENT_BECOME_TARGET)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	--e3:SetCondition(c18743209.spcon)
	--e3:SetOperation(c18743209.activate)
	--c:RegisterEffect(e3) 
end
os=require("os")
function c18743209.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
	if Duel.SelectYesNo(tp,aux.Stringid(18743209,7)) then
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(0,2))
	Duel.SelectOption(tp,aux.Stringid(18743209,val))
	Duel.SelectOption(1-tp,aux.Stringid(18743209,val))
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		return true
	else return false end
end
function c18743209.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c18743209.filter(c)
	return c:IsDestructable()
end
function c18743209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c18743209.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c18743209.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c18743209.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(3,6))
	Duel.SelectOption(tp,aux.Stringid(18743209,val))
	local g=Duel.GetMatchingGroup(c18743209.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()==0 or not c:IsRelateToEffect(e) then return end
	local tg=g:RandomSelect(1-tp,1)
	local tc=tg:GetFirst()
	if not tc:IsImmuneToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c18743209.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c18743209.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())
	local val=(math.random(0,2))
	Duel.SelectOption(tp,aux.Stringid(18743209,val))
	Duel.SelectOption(1-tp,aux.Stringid(18743209,val))
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
