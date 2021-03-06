--弹幕偏执症
function c19302011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19302011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19302011.target)
	e1:SetOperation(c19302011.activate)
	c:RegisterEffect(e1)
	if not c19302011.global_check then
		c19302011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c19302011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c19302011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_PSYCHO) then
		Duel.RegisterFlagEffect(rp,19302011,RESET_PHASE+PHASE_END,0,1)
	end
end
function c19302011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19302011)==0 end
	Duel.RegisterFlagEffect(tp,19302011,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c19302011.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19302011.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_PSYCHO)
end
function c19302011.filter(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19302011.filter1(c,e,tp)
	return c:GetLevel()==4
end
function c19302011.xyzfilter(c,mg)
	if c:GetRank()~=4 then return false end
	return c:IsXyzSummonable(mg)
end
function c19302011.mfilter1(c,exg)
	return exg:IsExists(c19302011.mfilter2,1,nil,c)
end
function c19302011.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c19302011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg1=Duel.GetFirstMatchingCard(c19302011.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local mg=Duel.GetMatchingGroup(c19302011.filter1,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c19302011.filter,tp,LOCATION_DECK,0,nil,e,tp)
	mg:AddCard(mg1)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg2:GetCount()>0
		and Duel.IsExistingMatchingCard(c19302011.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c19302011.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetFirstMatchingCard(c19302011.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local mg=Duel.GetMatchingGroup(c19302011.filter1,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c19302011.filter,tp,LOCATION_DECK,0,nil,e,tp)
	mg:AddCard(mg1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsPlayerCanSpecialSummonCount(tp,2)
		or mg2:GetCount()==0 or not Duel.IsExistingMatchingCard(c19302011.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) then return end
	local exg=Duel.GetMatchingGroup(c19302011.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg2:FilterSelect(tp,c19302011.mfilter1,1,1,nil,exg)
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	sg1:GetFirst():RegisterEffect(e1)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c19302011.filter1,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c19302011.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil)
	end
end
