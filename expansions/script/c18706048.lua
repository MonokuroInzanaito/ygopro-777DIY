--魔物少女 狂犬
function c18706048.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xabb),4,2)
	c:EnableReviveLimit()
	--EQ
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18706048,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c18706048.cost)
	e1:SetTarget(c18706048.tg)
	e1:SetOperation(c18706048.op)
	c:RegisterEffect(e1)
end
function c18706048.filter1(c)
	return c:IsAbleToDeck()
end
function c18706048.filter2(c)
	return c:IsAbleToRemove()
end
function c18706048.filter3(c)
	return c:IsAbleToGrave()
end
function c18706048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c18706048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(c18706048.filter1,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(c18706048.filter2,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=Duel.IsExistingTarget(c18706048.filter3,tp,0,LOCATION_ONFIELD,1,nil) 
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(18706048,1),aux.Stringid(18706048,2),aux.Stringid(18706048,3))
	elseif b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(3033102,1),aux.Stringid(18706048,2))
	elseif b1 and b3 then op=Duel.SelectOption(tp,aux.Stringid(3033102,1),aux.Stringid(18706048,3))
	elseif b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(3033102,2),aux.Stringid(18706048,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(3033102,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(3033102,2))+1
	else op=Duel.SelectOption(tp,aux.Stringid(3033102,3))+2 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c18706048.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c18706048.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,c18706048.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function c18706048.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	elseif e:GetLabel()==1 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end