--火舌图腾
local m=32822004
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)
	local e1=nil
	--pendulum initial
	orion.totemInitial(c,true,true)
	--atk up
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--nehibour atk up
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
		local seq=e:GetHandler():GetSequence()
		local tp=e:GetHandler():GetOwner()
		if seq<0 or seq>4 then return false end
		local g=Group.CreateGroup()
		if seq>0 and Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)) end
		if seq<4 and Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1) then g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1)) end
		return g:IsContains(c)
	end)
	e1:SetValue(2000)
	c:RegisterEffect(e1)
	--effect reg
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(orion.totemFlameReg)
	c:RegisterEffect(e1)
end
