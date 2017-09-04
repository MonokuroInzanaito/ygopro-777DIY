--惊鸿
local m=32844004
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
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.PyroToGrave,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.PyroToGrave,tp,LOCATION_DECK,0,1,1,nil)
		local tg=g:GetFirst()
		if tg==nil then return end
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	e1=e1:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--remove
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m+100)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.SpSummonPyro,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.SpSummonPyro,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tg=g:GetFirst()
		if tg==nil then return end
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end)
	c:RegisterEffect(e1)
	e1=Effect.Clone(e1)
	e1:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e1)
end
function cm.PyroToGrave(c,pc)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PYRO) and not c:IsCode(m)
end
function cm.SpSummonPyro(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_PYRO) and not c:IsCode(m)
end