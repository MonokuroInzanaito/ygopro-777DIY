--艺形魔-纸凤凰
function c21520188.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(c21520188.splimit)
	c:RegisterEffect(pe1)
	--fusion at end_phase
	local pe2=Effect.CreateEffect(c)
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	pe2:SetDescription(aux.Stringid(21520188,0))
	pe2:SetType(EFFECT_TYPE_QUICK_O)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCode(EVENT_FREE_CHAIN)
	pe2:SetCountLimit(1)
	pe2:SetHintTiming(TIMING_END_PHASE)
	pe2:SetCondition(c21520188.fcon)
	pe2:SetTarget(c21520188.ftg)
	pe2:SetOperation(c21520188.fsop)
	c:RegisterEffect(pe2)
	--INDESTRUCTABLE
	local pe3=Effect.CreateEffect(c)
	pe3:SetType(EFFECT_TYPE_SINGLE)
	pe3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	pe3:SetRange(LOCATION_PZONE)
	pe3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	pe3:SetCondition(c21520188.indcon)
	pe3:SetValue(c21520188.indval)
	c:RegisterEffect(pe3)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(21520188,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21520188)
	e1:SetCost(c21520188.descost)
	e1:SetTarget(c21520188.destg)
	e1:SetOperation(c21520188.desop)
	c:RegisterEffect(e1)
	--destroy more
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520188,3))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520188)
	e2:SetTarget(c21520188.dmtg)
	e2:SetOperation(c21520188.dmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520188,4))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,21520188)
	e4:SetCondition(c21520188.spcon)
	e4:SetTarget(c21520188.sptg)
	e4:SetOperation(c21520188.spop)
	c:RegisterEffect(e4)
end
function c21520188.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x490) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c21520188.fcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_END
end
function c21520188.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c21520188.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x490)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21520188.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c21520188.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		local res=Duel.IsExistingMatchingCard(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c21520188.fsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c21520188.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local sg1=Duel.GetMatchingGroup(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.ConfirmCards(1-tp,mat1)
			Duel.SendtoDeck(mat1,tp,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		Duel.BreakEffect()
		local dct=Duel.GetMatchingGroupCount(c21520188.desfilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,dct,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c21520188.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x490)
end
function c21520188.indcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
end
function c21520188.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c21520188.rmfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x490)
end
function c21520188.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(c21520188.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520188.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520188.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21520188.cffilter(c)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and not c:IsPublic()
end
function c21520188.spsfilter(c,attr,e,tp)
	return c:IsAttribute(attr) and c:IsSetCard(0x490) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520188.spsfilter1(c,e,tp)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsSetCard(0x490) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520188.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local hg=Duel.GetMatchingGroup(c21520188.cffilter,tp,LOCATION_HAND,0,nil,e,tp)
			local g=Duel.GetMatchingGroup(c21520188.spsfilter1,tp,LOCATION_DECK,0,nil,e,tp)
			if ((hg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)) 
			  or (hg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)))
			  and tc:IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(21520188,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				local cg=Duel.SelectMatchingCard(tp,c21520188.cffilter,tp,LOCATION_HAND,0,1,1,nil)
				local attr=cg:GetFirst():GetAttribute()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local spg=Duel.SelectMatchingCard(tp,c21520188.spsfilter,tp,LOCATION_DECK,0,1,1,nil,attr,e,tp)
				Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c21520188.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsDestructable() end
	if chk==0 then 
		local ct=Duel.GetMatchingGroupCount(c21520188.desfilter,tp,LOCATION_ONFIELD,0,nil)
		return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c21520188.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=Duel.GetMatchingGroupCount(c21520188.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21520188.spfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x490) and not c:IsReason(REASON_RULE)
end
function c21520188.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520188.spfilter,1,nil,tp)
end
function c21520188.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
end
function c21520188.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:ResetFlagEffect(21520188) 
	end
end
