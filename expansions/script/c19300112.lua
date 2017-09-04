--幻想镜现诗·逆转的命运之轮
function c19300112.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19300112.target)
	e1:SetOperation(c19300112.activate)
	c:RegisterEffect(e1)
end
function c19300112.filter(c)
	return c:IsSetCard(0x193) and c:IsFacedown()
end
function c19300112.filter1(c)
	return c:IsSetCard(0x193) and c:IsFaceup()
end
function c19300112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300112.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c19300112.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c19300112.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19300112.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0 then
		local g1=Duel.GetMatchingGroup(c19300112.filter1,tp,LOCATION_MZONE,0,nil)
		if g1:GetCount()>0 then
			Duel.BreakEffect()
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			if g2:GetCount()>0 then
				Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
			end
			if g1:GetCount()>2 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(0,1)
				e1:SetValue(c19300112.aclimit1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c19300112.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end