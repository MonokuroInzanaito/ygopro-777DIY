--巨怪工厂 巨兽碾压
function c20322032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c20322032.descon)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c20322032.scon)
	e4:SetTarget(c20322032.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e5)
end
function c20322032.sumlimit(e,c)
	return c:IsLevelBelow(6)
end
function c20322032.filter(c)
	return c:IsSetCard(0x282) and c:IsLevelAbove(10)
end
function c20322032.scon(e)
	return Duel.IsExistingMatchingCard(c20322032.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c20322032.descon(e)   
	local p=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c20322032.filter,p,LOCATION_MZONE,0,1,nil)
end