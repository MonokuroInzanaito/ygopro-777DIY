--红莲的舞姬 Hitoyo
function c10981017.initial_effect(c)
	aux.EnablePendulumAttribute(c) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c10981017.ptarget)
	e1:SetValue(-1)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c10981017.ptarget)
	e2:SetValue(1)
	c:RegisterEffect(e2)   
end
function c10981017.ptarget(e,c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
