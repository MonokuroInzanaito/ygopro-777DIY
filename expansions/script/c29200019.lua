--
function c29200019.initial_effect(c)
	c:SetUniqueOnField(1,0,29200019)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c29200019.ffilter,c29200019.ffilter,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c29200019.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c29200019.spcon)
	e2:SetOperation(c29200019.spop)
	c:RegisterEffect(e2)
	--summon,flip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c29200019.handes)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c29200019.efilter)
	c:RegisterEffect(e4)
end
c29200019[0]=0
function c29200019.filter1(c)
	return not c:IsPublic()
end
function c29200019.handes(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_MZONE or id==c29200019[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c29200019[0]=id
	local cg=Duel.GetMatchingGroup(c29200019.filter1,tp,0,LOCATION_HAND,nil)
	if cg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(29200019,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local sg=cg:Select(1-tp,1,1,nil)
			--Duel.ConfirmCards(tp,sg)
			local tc=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
	else 
		Duel.NegateEffect(ev) 
	end
end
function c29200019.efilter(e,re,rp)
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c29200019.ffilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ)
end
function c29200019.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c29200019.spfilter1(c,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c29200019.spfilter2,1,c)
end
function c29200019.spfilter2(c)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_XYZ+TYPE_SYNCHRO) and c:IsCanBeFusionMaterial()
end
function c29200019.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c29200019.spfilter1,1,nil,tp)
end
function c29200019.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c29200019.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c29200019.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end