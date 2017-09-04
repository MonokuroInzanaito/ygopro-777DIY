--大圣女 世羽
function c18700103.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c18700103.xyzfilter,5,3,c18700103.ovfilter,aux.Stringid(18700103,0))
	c:EnableReviveLimit()
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c18700103.efilter)
	c:RegisterEffect(e1)
	--EQ
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(69610924,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c18700103.cost)
	e1:SetTarget(c18700103.regtg)
	e1:SetOperation(c18700103.regop)
	c:RegisterEffect(e1)
end
function c18700103.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==4 and c:IsSetCard(0xab0) and c:GetOverlayCount()==0
end
function c18700103.xyzfilter(c)
	return c:IsSetCard(0xab0) or c:IsSetCard(0xabb)
end
function c18700103.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c18700103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18700103.filter(c)
	return c:IsAbleToRemove() and c:IsFacedown()
end
function c18700103.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18700103.filter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c18700103.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c18700103.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18700103.filter,tp,0,LOCATION_ONFIELD,nil)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	end
end
