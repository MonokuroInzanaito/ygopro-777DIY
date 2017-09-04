--6th-残肢乱置的失败品
function c66600609.initial_effect(c)
	--xyz summon
	  aux.AddXyzProcedure(c,c66600609.matfilter,3,2)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600609,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c66600609.cost)
	e1:SetCondition(c66600609.condition)
	e1:SetTarget(c66600609.target)
	e1:SetOperation(c66600609.operation)
	c:RegisterEffect(e1)
end
function c66600609.matfilter(c)
	return c:IsSetCard(0x66e)
end
function c66600609.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==1-tp then
		return  ph==PHASE_MAIN1 or ph==PHASE_MAIN2
		else return true
	end
end
function c66600609.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600609.filter(c,tp)
	return  (c:IsAbleToChangeControler() or c:IsControler(tp))
		and not c:IsType(TYPE_TOKEN) 
end
function c66600609.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66600609.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c66600609.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c66600609.filter,tp,0,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c66600609.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		  if tc:IsSetCard(0x66e) then
		Duel.Draw(tp,1)
	end
end
end