--生命与死亡 重构
function c60159022.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c60159022.condition2)
	e1:SetTarget(c60159022.target2)
	e1:SetOperation(c60159022.activate2)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c60159022.negcon)
	e2:SetTarget(c60159022.negtg)
	e2:SetOperation(c60159022.negop)
	c:RegisterEffect(e2)
end
function c60159022.negfilter(c,tp)
	return c:IsFaceup() and (((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) 
		and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)))
		and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c60159022.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c60159022.negfilter,1,nil,tp) and rp~=e:GetHandlerPlayer() and Duel.IsChainNegatable(ev)
end
function c60159022.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c60159022.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local s=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
		local p=Duel.GetChainInfo(s-1,CHAININFO_TARGET_CARDS)
		if Duel.SendtoDeck(p,nil,2,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c60159022.filter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60159022.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and ((tc:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or t(c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) 
		and (tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_FUSION) or tc:IsType(TYPE_XYZ)))
end
function c60159022.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60159022.filter(c,e,tp)
	return ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and (c:GetLevel()==3 or c:GetLevel()==4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c60159022.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack()~=0 then
		local atk=Duel.GetAttacker()
		Duel.Destroy(atk,REASON_EFFECT)
		local atk2=Duel.GetAttackTarget()
		if atk2~=nil and Duel.SendtoDeck(atk2,nil,2,REASON_EFFECT)~=0 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c60159022.filter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60159022.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c60159022.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x13,2,REASON_COST)
end
function c60159022.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c60159022.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end