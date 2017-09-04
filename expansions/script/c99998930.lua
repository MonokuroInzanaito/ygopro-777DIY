--月夜的魔女
function c99998930.initial_effect(c)
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c99998930.fuscon)
	e3:SetOperation(c99998930.fusop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99998930,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e)
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end)
	e1:SetTarget(c99998930.sptg)
	e1:SetOperation(c99998930.spop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c99998930.efcon)
	e3:SetOperation(c99998930.efop)
	c:RegisterEffect(e3)
end
c99998930.miracle_synchro_fusion=true
function c99998930.mtfilter1(c,mg,sg,exg,chkf)
	if sg:GetCount()==0 and exg:IsContains(c) then return false end
	sg:AddCard(c)
	local res=(sg:GetCount()<3 and mg:IsExists(c99998930.mtfilter1,1,sg,mg,sg,exg,chkf))
		or (sg:GetCount()==3 and c99998930.fusgoal(sg,exg,chkf))
	sg:RemoveCard(c)
	return res
end
function c99998930.fusgoal(sg,exg,chkf)
	--if sg:IsExists(c99998930.chkfilter,nil,3,exg) then return false end
	if chkf~=PLAYER_NONE and not sg:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
	return sg:IsExists(c99998930.fusfilter,1,nil,sg,1)  
end
function c99998930.fusfilter(c,sg,n)
	local tl={TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ}
	if not c:IsFusionType(tl[n]) then return false end
	if n==3 then return true end
	local sg1=sg:Filter(aux.TRUE,c)
	return sg1:IsExists(c99998930.fusfilter,1,nil,sg1,n+1)
end
function c99998930.chkfilter(c,exg)
	return exg:IsContains(c)
end
function c99998930.exfilter(c,fc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsCanBeFusionMaterial(fc) and c~=fc
end
function c99998930.fuscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local sg=Group.CreateGroup()
	local chkf=bit.band(chkfnf,0xff)
	if gc then sg:AddCard(gc) end
	local exg=Duel.GetMatchingGroup(c99998930.exfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,sg,e:GetHandler())
	mg:Merge(exg)
	return mg:IsExists(c99998930.mtfilter1,1,sg,mg,sg,exg,chkf)
end
function c99998930.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c=e:GetHandler()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,c)
	local sg=Group.CreateGroup()
	local chkf=bit.band(chkfnf,0xff)
	if gc then sg:AddCard(gc) end
	local exg=Duel.GetMatchingGroup(c99998930.exfilter,tp,LOCATION_EXTRA,0,sg,c)
	mg:Merge(exg)
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,c99998930.mtfilter1,1,1,sg,mg,sg,exg,chkf)
		sg:Merge(g)
	until sg:GetCount()==3
	local rg=sg:Filter(c99998930.chkfilter,nil,exg)
	for rc in aux.Next(rg) do
		rc:RegisterFlagEffect(99998930,RESET_CHAIN,0,1)
	end
	Duel.SetFusionMaterial(sg)
end
c99998930.OriginalSetMaterial=Card.SetMaterial
function c99998930.SetMaterial(c,g)
	c99998930.OriginalSetMaterial(c,g)
	if not g then return end
	local rg=g:Filter(c99998930.rfilter,nil)
	if rg:GetCount()>0 then
		g:Sub(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT)
		for rc in aux.Next(rg) do
			rc:ResetFlagEffect(99998930)
		end
	end
end
function c99998930.rfilter(c)
	return c:GetFlagEffect(99998930)>0
end
function c99998930.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99998930.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99998930.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99998930.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99998930.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		if lv<=0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(lv)
		c:RegisterEffect(e1)
	end
end
function c99998930.efcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_SYNCHRO+REASON_XYZ)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c99998930.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(99998930,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,re,tp)
		return tp~=e:GetHandlerPlayer()
	end)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end