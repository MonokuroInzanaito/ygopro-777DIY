--夕诀
local m=32844003
local cm=_G["c"..m]
if not orion then
	if not pcall(function() require("expansions/script/c32800000") end) then require("script/c32800000") end
end
function cm.initial_effect(c)
	--special summon
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(orion.conditionNoMonsterSelf)
	c:RegisterEffect(e1)
	--summon success
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local c=e:GetHandler()
		if chk==0 then return Duel.IsExistingMatchingCard(cm.PendulumPyro,tp,LOCATION_DECK,0,1,nil,c) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local g=Duel.SelectMatchingCard(tp,cm.PendulumPyro,tp,LOCATION_DECK,0,1,1,nil,c)
		local tg=g:GetFirst()
		if tg==nil then return end
		Duel.SendtoExtraP(tg,tp,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	e1=e1:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--remove
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m+100)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.PendulumPyro,tp,LOCATION_EXTRA,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.PendulumPyro,tp,LOCATION_EXTRA,0,1,1,nil)
		local tg=g:GetFirst()
		if tg==nil then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end)
	c:RegisterEffect(e1)
	e1=Effect.Clone(e1)
	e1:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e1)
end
function cm.PendulumPyro(c,pc)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_PYRO) and not c:IsCode(m)
end
function cm.PendulumPyroToHand(c,pc)
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsRace(RACE_PYRO) and not c:IsCode(m)
end