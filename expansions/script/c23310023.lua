--灵魂歌手
function c23310023.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23310023,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c23310023.discon)
	e1:SetCost(c23310023.discost)
	e1:SetTarget(c23310023.distg)
	e1:SetOperation(c23310023.disop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23310023,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,23310023)
	e2:SetTarget(c23310023.tdtg)
	e2:SetOperation(c23310023.tdop)
	c:RegisterEffect(e2)
end
function c23310023.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c23310023.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c23310023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,1,1)>e:GetHandler():GetOverlayCount() end
end
function c23310023.disfilter(c,oc)
	return c:GetOverlayTarget()==oc
end
function c23310023.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetOverlayCount(tp,1,1)>e:GetHandler():GetOverlayCount() then
		local g1=Duel.GetOverlayGroup(tp,1,1)
		g1:Remove(c23310023.disfilter,nil,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23310023,1))
		local mg2=g1:Select(tp,1,2,nil)
		local oc1=mg2:GetFirst():GetOverlayTarget()
		local oc2=mg2:GetNext():GetOverlayTarget()
		Duel.Overlay(e:GetHandler(),mg2)
		Duel.RaiseSingleEvent(oc1,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		if oc2~=oc1 then 
			Duel.RaiseSingleEvent(oc2,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
	end
end
function c23310023.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) end
end
function c23310023.filter(c)
	return c:GetOverlayCount()==0 and c:IsType(TYPE_XYZ)
end
function c23310023.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,1,REASON_EFFECT)
	if sg:GetCount()==0 then return end
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,532)
		sg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	end
	if sg:GetFirst()==e:GetHandler() then
		sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local dg=Duel.GetMatchingGroup(c23310023.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(23310023,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	else
		sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end