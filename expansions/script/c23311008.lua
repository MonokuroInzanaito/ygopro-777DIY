--阴阳万归一
function c23311008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23311008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23311008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c23311008.target)
	e1:SetOperation(c23311008.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23311008,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,123311008)
	e2:SetCost(c23311008.thcost)
	e2:SetTarget(c23311008.thtg)
	e2:SetOperation(c23311008.thop)
	c:RegisterEffect(e2)
end
function c23311008.filter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c23311008.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c23311008.exfilter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c23311008.exfilter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c23311008.filter2(c,e,tp,m,sg,f,chkf)
	local mg=m:Clone()
	if c:IsCode(23311006) then mg:Merge(sg) end
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
--fusion monster filter
function c23311008.filter3(c,e,tp,m,sg,f,chkf)
	local mg=m:Clone()
	if c:IsCode(23311006) then mg:Merge(sg) end
	mg:RemoveCard(c)
	if c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then
		return c:CheckFusionMaterial(mg,nil,chkf)
	else return false end
end
function c23311008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c23311008.filter0,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local sg=Duel.GetMatchingGroup(c23311008.exfilter0,tp,LOCATION_EXTRA,0,nil)
		local res=Duel.IsExistingMatchingCard(c23311008.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,sg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c23311008.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,sg,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c23311008.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c23311008.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c23311008.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c23311008.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,sg,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c23311008.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,sg,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg0=sg1:Clone()
		if sg2 then sg0:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg0:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsCode(23311006) then mg1:Merge(sg) end
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	else
		local cg1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_MZONE,0)
		local cg2=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if cg1:GetCount()>1 and cg2:IsExists(Card.IsFacedown,1,nil)
			and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,27581098) then
			Duel.ConfirmCards(1-tp,cg1)
			Duel.ConfirmCards(1-tp,cg2)
			Duel.ShuffleHand(tp)
		end
	end
end
function c23311008.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c23311008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23311008.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c23311008.cfilter,1,1,REASON_COST)
end
function c23311008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c23311008.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end