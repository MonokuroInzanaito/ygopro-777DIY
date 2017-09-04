--哲尔 闪耀的生命
function c60159008.initial_effect(c)
	--synchro limit
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e12:SetValue(c60159008.synlimit)
	c:RegisterEffect(e12)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,60159008)
	e1:SetCondition(c60159008.drcon)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCountLimit(1,6015008)
	e2:SetCondition(c60159008.sccon)
	e2:SetTarget(c60159008.sctg)
	e2:SetOperation(c60159008.scop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,60159098+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c60159008.spcon)
	e3:SetTarget(c60159008.target)
	e3:SetOperation(c60159008.operation)
	c:RegisterEffect(e3)
	if not c60159008.global_check then
		c60159008.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c60159008.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60159008.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsLocation(LOCATION_EXTRA) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60159008,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60159008,RESET_PHASE+PHASE_END,0,1) end
end
function c60159008.synlimit(e,c)
	if not c then return false end
	return not ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159008.handfilter(c)
	return c:IsType(TYPE_MONSTER) and not ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24)))
end
function c60159008.drcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return not g:IsExists(c60159008.handfilter,1,nil)
end
function c60159008.mfilter(c)
	return c:IsFaceup() and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and not c:IsType(TYPE_TOKEN)
end
function c60159008.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c60159008.sccon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c60159008.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c60159008.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c60159008.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60159008.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60159008.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c60159008.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g,1,5)
	end
end
function c60159008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFlagEffect(tp,60159007)==0
end
function c60159008.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) and Duel.IsExistingMatchingCard(c60159008.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c60159008.filter2(c,e,tp,lv)
	return c:GetRank()==lv and ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c60159008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c60159008.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c60159008.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c60159008.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60159008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c60159008.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if sg:GetCount()>0 then
		local tc2=sg:GetFirst()
		if tc2 then
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(tc2,g)
			tc2:CompleteProcedure()
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60159008.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c60159008.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end