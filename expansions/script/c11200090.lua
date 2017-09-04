--全智龙 赫利姆瑟尔斯
--Scripted by Real_Scl
function c11200090.initial_effect(c)
	--Lv up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200090,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11200090)
	e1:SetCondition(c11200090.lvcon)
	e1:SetCost(c11200090.lvcost)
	e1:SetTarget(c11200090.lvtg)
	e1:SetOperation(c11200090.lvop)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200090,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,11200190)
	e2:SetCondition(c11200090.spcon)
	e2:SetTarget(c11200090.sptg)
	e2:SetOperation(c11200090.spop)
	c:RegisterEffect(e2) 
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c11200090.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c11200090.efcon)
	e4:SetOperation(c11200090.efop)
	c:RegisterEffect(e4)
end
function c11200090.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsRace(RACE_BEAST)
end
function c11200090.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11200090.cfilter,1,nil,tp)
end
function c11200090.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c11200090.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c11200090.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c11200090.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e) or g:GetCount()<=0 then return end
	local lv=g:GetSum(c11200090.sumfilter)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(lv)
	c:RegisterEffect(e1)
end
function c11200090.sumfilter(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel()
	end
end
function c11200090.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE and e:GetLabel()==1
end
function c11200090.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK)
end
function c11200090.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11200090.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local sg=g:Filter(c11200090.spfilter2,nil)
		if sg:GetCount()>0 then
		   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c11200090.spfilter(c,e,tp)
	return c:IsCode(11200090) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200090.spfilter2(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c11200090.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsRace,1,nil,RACE_BEAST) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c11200090.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c11200090.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(11200090,2))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11200090.adcon)
	e1:SetOperation(c11200090.adop)
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
function c11200090.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c11200090.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11200090.adfilter,tp,LOCATION_MZONE,0,nil)
	if not c:IsRelateToEffect(e) or g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c:GetAttack())
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(c:GetDefense())
		tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
end
function c11200090.adfilter(c)
	return c:IsCode(11200090) and c:IsFaceup()
end