--图腾魔像
local m=32822005
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)
	local e1=nil
	--summon from hand
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	e1:SetTarget(orion.targetSummonTribute)
	e1:SetOperation(orion.operationSummonAdvance)
	c:RegisterEffect(e1)
	--skip M1
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return orion.isSummonAdvance(e)
	end)
	c:RegisterEffect(e1)
	--summon destroy
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return orion.isSummonAdvance(e)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return true end
		local g=Duel.GetMatchingGroup(orion.monsterFaceupNotTotem,tp,LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(orion.monsterFaceupNotTotem,tp,LOCATION_MZONE,0,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	--leave destroy
	--e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,2))
	--e1:SetCategory(CATEGORY_DESTROY)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetCode(EVENT_LEAVE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	--e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		--return orion.isSummonAdvance(e) and orion.isLeftFaceup(e)
	--end)
	--e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		--if chk==0 then return true end
		--local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
		--Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	--end)
	--e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		--local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
		--Duel.Destroy(g,REASON_EFFECT)
	--end)
	--c:RegisterEffect(e1)
	--④：上级召唤的这张卡不会被战斗破坏，战斗发生的对自己的战斗伤害由对方代受，不受原本的等级或者阶级比这张卡的等级低的对方怪兽的效果影响。
	--summon reg
	--e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--e1:SetCondition(orion.conditionSummonAdvance)
	--e1:SetValue(1)
	--c:RegisterEffect(e1)
	--e1=Effect.Clone(e1)
	--e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	--c:RegisterEffect(e1)
	--e1=Effect.Clone(e1)
	--e1:SetCode(EFFECT_IMMUNE_EFFECT)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetValue(aux.qlifilter)
	--c:RegisterEffect(e1)
	--tohand
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(orion.costDiscardOneCard)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(orion.totemSearchAllFilter,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,orion.totemSearchAllFilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			--Duel.ShuffleHand(tp)
			--Duel.BreakEffect()
			--if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) then return end
			--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			--local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
			--if g:GetCount()>0 then
				--Duel.Destroy(g,REASON_EFFECT)
			--end
		end
	end)
	c:RegisterEffect(e1)
end
