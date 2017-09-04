--治疗之泉图腾
local m=32822002
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)
	local e1=nil
	--pendulum initial
	orion.totemInitial(c,true,true)
	--aviod effect destroy
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCountLimit(1)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return eg:IsExists(orion.totemEffectReplaceMonsterFilter,1,nil,tp) end
		return true
	end)
	e1:SetValue(function(e,c)
		return orion.totemEffectReplaceMonsterFilter(c,e:GetHandlerPlayer())
	end)
	c:RegisterEffect(e1)
	--destroy replace
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return eg:IsExists(orion.totemReplaceFilter,1,e:GetHandler(),tp) end
		return Duel.SelectYesNo(tp,aux.Stringid(m,0))
	end)
	e1:SetValue(function(e,c)
		return orion.totemReplaceFilter(c,e:GetHandlerPlayer())
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	end)
	c:RegisterEffect(e1)
	--effect reg
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(orion.totemHealingStreamReg)
	c:RegisterEffect(e1)
end
