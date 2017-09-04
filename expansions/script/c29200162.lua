--凋叶棕-改-光芒
function c29200162.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c29200162.mfilter,7,2,c29200162.ovfilter,aux.Stringid(29200162,0),2,c29200162.xyzop)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c29200162.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c29200162.atkval)
	c:RegisterEffect(e2)
	--effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c29200162.cost)
	e5:SetTarget(c29200162.target)
	e5:SetOperation(c29200162.operation)
	c:RegisterEffect(e5)
end
function c29200162.mfilter(c)
	return c:IsSetCard(0x53e0) 
end
function c29200162.ovfilter(c)
	return c:IsFaceup() and c:IsCode(29200127)
end
function c29200162.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29200162)==0 end
	Duel.RegisterFlagEffect(tp,29200162,RESET_PHASE+PHASE_END,0,1)
end
function c29200162.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c29200162.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c29200162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local tc=c:GetOverlayCount()
	e:SetLabel(tc)
	e:GetHandler():RemoveOverlayCard(tp,tc,tc,REASON_COST)
end
function c29200162.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c29200162.filter1(c)
	return c:IsSetCard(0x53e0) and c:IsType(TYPE_MONSTER) 
end
function c29200162.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local rg=g:Filter(c29200162.filter1,nil)
	while rg:GetCount()>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		if tc and tc:IsAbleToGrave() then
			rg:RemoveCard(tc)
			g:RemoveCard(tc)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	Duel.Overlay(c,g)
end
