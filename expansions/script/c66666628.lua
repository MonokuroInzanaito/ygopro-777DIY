--白之夜的后继者-乌木子
function c66666628.initial_effect(c)
	c:SetUniqueOnField(1,0,66666628)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),6,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66666628,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c66666628.xyzcondition)
	e1:SetOperation(c66666628.xyzoperation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c66666628.rmcost)
	e3:SetTarget(c66666628.rmtg)
	e3:SetOperation(c66666628.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(0x14000)
	--e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(function(e)
		local c=e:GetHandler()
		return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
	end)
	--e4:SetCost(c66666628.spcost)
	e4:SetTarget(c66666628.sptg)
	e4:SetOperation(c66666628.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c66666628.reptg)
	e5:SetValue(c66666628.repval)
	c:RegisterEffect(e5)
end
function c66666628.cfilter(c)
	return c:IsSetCard(0x661) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c66666628.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x661) and c:IsRace(RACE_WARRIOR) and not c:IsType(TYPE_XYZ)
end
function c66666628.xyzcondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c66666628.xyzfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>=1 and Duel.IsExistingMatchingCard(c66666628.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c66666628.xyzoperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.DiscardHand(tp,c66666628.cfilter,1,1,REASON_COST,e:GetHandler())
	local mg=Duel.GetMatchingGroup(c66666628.xyzfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=mg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) then
			local sg=tc:GetOverlayGroup()
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_RULE)
			end
		end
		tc=g:GetNext()
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c66666628.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66666628.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x661)
end
function c66666628.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66666628.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666628.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666628.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66666628.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(600)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(c66666610.efilter)
		tc:RegisterEffect(e2)
	end
end
function c66666628.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66666628.spfilter(c,e,tp)
	return c:IsSetCard(0x661) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4)
end
function c66666628.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c66666628.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c66666628.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66666628.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(6)
		tc:RegisterEffect(e1,true)
end
function c66666628.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x661)
end
function c66666628.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c66666628.repfilter,1,nil,tp) end
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(66666628,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local g=eg:Filter(c66666628.repfilter,nil,tp)
		local tc=g:GetFirst()
		while tc do
			e:SetLabelObject(tc)
			tc=g:GetNext()
		end
		return true
	else return false end
end
function c66666628.repval(e,c)
	return c==e:GetLabelObject()
end