--虹纹骑士长·黑统
function c1000197.initial_effect(c)
	c:EnableReviveLimit()
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1000197.spcon)
	e1:SetOperation(c1000197.spop)
	c:RegisterEffect(e1)
	--①
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000069,12))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1000197.descost)
	e2:SetTarget(c1000197.destg)
	e2:SetOperation(c1000197.desop)
	c:RegisterEffect(e2)
	--②
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1000197.drstg)
	e3:SetValue(c1000197.drval)
	c:RegisterEffect(e3)
end
function c1000197.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x200)
end
function c1000197.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x200) and c:IsAbleToDeckAsCost()
end
function c1000197.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1000197.spfilter,tp,LOCATION_REMOVED,0,3,nil)
end
function c1000197.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000197.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c1000197.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x200) and c:IsAbleToDeckAsCost()
end
function c1000197.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1000197.desfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1000197.desfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()~=1 then return end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1000197.filter(c)
	return c:IsDestructable()
end
function c1000197.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000197.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1000197.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1000197.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1000197.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c1000197.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_OATH)
	e:GetHandler():RegisterEffect(e2)
	end
end
function c1000197.splimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x200)
end
function c1000197.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x200)
end
function c1000197.drstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1000197.repfilter,1,nil,tp) end
	if Duel.IsExistingMatchingCard(c1000197.desfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1000069,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,c1000197.desfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		local g=eg:Filter(c1000197.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.SendtoDeck(tg,nil,2,REASON_COST)
		return true
	else return false end
end
function c1000197.drval(e,c)
	return c==e:GetLabelObject()
end