--回忆「Terrible Souvenir」
function c29200014.initial_effect(c)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,29200014+EFFECT_COUNT_CODE_OATH)
	e5:SetCost(c29200014.cost1)
	e5:SetTarget(c29200014.target1)
	e5:SetOperation(c29200014.activate1)
	c:RegisterEffect(e5)
	--revive 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29200014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c29200014.cost)
	e1:SetTarget(c29200014.target)
	e1:SetOperation(c29200014.operation)
	c:RegisterEffect(e1)
end
c29200014.satori_prpr_list=true
function c29200014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c29200014.filter(c,e,tp)
	return c:IsSetCard(0x33e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29200014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29200014.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c29200014.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29200014.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29200014.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c29200014.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c29200014.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x33e0) and c:IsType(TYPE_PENDULUM)
end
function c29200014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(c29200014.exfilter,tp,LOCATION_SZONE,0,nil)<2
		and Duel.IsExistingMatchingCard(c29200014.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c29200014.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29200014.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	  if Duel.GetMatchingGroupCount(c29200014.exfilter,tp,LOCATION_SZONE,0,nil)<2 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	   end
	end
end