--热炽图腾
local m=32822009
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)
	local e1=nil
	--pendulum initial
	orion.totemInitial(c,true,false)
	--destroy
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(orion.totemConditionHasAnotherTotem)
	e1:SetTarget(orion.targetDestroyAnotherCard)
	e1:SetOperation(orion.operationDestroyBothSync)
	c:RegisterEffect(e1)
	--summon from extra
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	e1:SetTarget(orion.targetSummonTribute)
	e1:SetOperation(orion.operationSummonAdvance)
	c:RegisterEffect(e1)
	--activate limit
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(orion.valueNotImmune)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOwner()==Duel.GetTurnPlayer() and orion.isSummonAdvance(e)
	end)
	c:RegisterEffect(e1)
	--leave destroy
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return orion.isSummonAdvance(e) and orion.isLeftFaceup(e)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return true end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsPlayerCanSpecialSummonMonster(tp,32822010,0,0x4011,3250,2550,9,RACE_PYRO,ATTRIBUTE_FIRE) then
			Duel.BreakEffect()
			for i=1,2 do
				local token=Duel.CreateToken(tp,32822010)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
	end)
	c:RegisterEffect(e1)
	--④：这张卡的上级召唤不会被无效化。上级召唤的这张卡不能被解放，不会被战斗破坏，战斗发生的对自己的战斗伤害由对方代受，不受对方的魔法·陷阱卡的效果影响，也不受原本的等级或者阶级比这张卡的等级低的对方怪兽的效果影响。
	--summon reg
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
	end)
	c:RegisterEffect(e1)
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
	--e1:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	--e1:SetRange(LOCATION_MZONE)
	--c:RegisterEffect(e1)
	--e1=Effect.Clone(e1)
	--e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	--c:RegisterEffect(e1)
	--e1=Effect.Clone(e1)
	--e1:SetCode(EFFECT_IMMUNE_EFFECT)
	--e1:SetValue(orion.valueQliImmuneAdvance)
	--c:RegisterEffect(e1)
end
