--要塞
function c18781002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c18781002.splimcon)
	e2:SetTarget(c18781002.splimit)
	c:RegisterEffect(e2)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c18781002.condition)
	e2:SetTarget(c18781002.indtg)
	e2:SetValue(c18781002.indval)
	c:RegisterEffect(e2)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c18781002.condition)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--30459350 chk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(30459350)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c18781002.condition)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
end
function c18781002.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c18781002.splimit(e,c)
	return not c:IsSetCard(0xabb)
end
function c18781002.dfilter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and c:IsDEFENSEBelow(2500)
end
function c18781002.ccfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6abb) and c:IsType(TYPE_XYZ)
end
function c18781002.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c18781002.ccfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c18781002.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end 
function c18781002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c18781002.ccfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) and
	Duel.IsExistingMatchingCard(c18781002.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c18718729.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function c18781002.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c18781002.ccfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)  then
		local sg1=Duel.GetMatchingGroup(c18781002.dfilter,tp,0,LOCATION_MZONE,nil)
		local sg2=Duel.Destroy(sg1,REASON_EFFECT)
end
end
function c18781002.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_EFFECT)
		and c:IsSetCard(0xabb)
end
function c18781002.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c18781002.indfilter,1,nil,tp) end
	return true
end
function c18781002.indval(e,c)
	return c18781002.indfilter(c,e:GetHandlerPlayer())
end