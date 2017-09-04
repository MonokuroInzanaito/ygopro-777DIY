--BB
function c18700006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c18700006.ovfilter,aux.Stringid(38495396,1),3,c18700006.xyzop)
	c:EnableReviveLimit()
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18700006.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--DESTROY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73964868,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,18700006)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c18700006.condition)
	e1:SetCost(c18700006.cost)
	e1:SetTarget(c18700006.tg)
	e1:SetOperation(c18700006.op)
	c:RegisterEffect(e1)
end
function c18700006.ovfilter(c)
	return c:IsFaceup() and c:IsCode(18700002) or c:IsCode(18700003)
end
function c18700006.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),LOCATION_MZONE,1)*700
end
function c18700006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=4000
end
function c18700006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18700006.schfilter(c,e,tp)
	return  c:IsType(TYPE_XYZ) and c:IsRace(RACE_FAIRY)
end
function c18700006.desfilter(c)
	return c:IsDestructable()
end
function c18700006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(c18700006.desfilter,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c18700006.schfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(18700006,1),aux.Stringid(18700006,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(18700006,1))
	else op=Duel.SelectOption(tp,aux.Stringid(18700006,2))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c18700006.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c18700006.schfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c18700006.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
	local ct=Duel.Destroy(tc,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end