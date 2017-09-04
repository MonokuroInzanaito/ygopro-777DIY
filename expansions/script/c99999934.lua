--传说之弓兵 喀戎
function c99999934.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35950025,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c99999934.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c99999934.sptg)
	e2:SetOperation(c99999934.spop)
	c:RegisterEffect(e2)
	--act limit
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e3:SetCode(EVENT_SUMMON_SUCCESS)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetCondition(c99999934.limcon)
	-- e3:SetOperation(c99999934.limop)
	-- c:RegisterEffect(e3)
	-- local e4=e3:Clone()
	-- e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- c:RegisterEffect(e4)
	-- local e5=Effect.CreateEffect(c)
	-- e5:SetType(EFFECT_TYPE_FIELD)
	-- e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	-- e5:SetTargetRange(0,1)
	-- e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	-- e5:SetRange(LOCATION_MZONE)
	-- e5:SetValue(c99999934.aclimit)
	-- e5:SetCondition(c99999934.actcon)
	-- c:RegisterEffect(e5)
	-- local e6=Effect.CreateEffect(c)
	-- e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e6:SetRange(LOCATION_MZONE)
	-- e6:SetCode(EVENT_CHAIN_END)
	-- e6:SetOperation(c99999934.limop2)
	-- c:RegisterEffect(e6)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c99999934.effcon)
	e3:SetOperation(c99999934.effop1)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_PRE_MATERIAL)
	e4:SetCondition(c99999934.effcon)
	e4:SetOperation(c99999934.effop2)
	c:RegisterEffect(e4)
end
function c99999934.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c99999934.spfilter(c,e,tp)
	return (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7)) and c:IsCanBeSpecialSummoned(e,POS_FACEUP_DEFENSE,tp,false,false) and c:GetCode()~=99999934 and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE+LOCATION_HAND))
end
function c99999934.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  Duel.IsExistingMatchingCard(c99999934.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA)
end
function c99999934.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99999934.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc and  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c99999934.limit)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	tc:RegisterEffect(e4)
end
end
function c99999934.limit(e,c)
	if not c then return false end
	return not (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e7))
end
-- function c99999934.limfilter(c,tp)
	-- return c:GetSummonPlayer()==tp and  c:IsFaceup() and  (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7))
-- end
-- function c99999934.limcon(e,tp,eg,ep,ev,re,r,rp)
	-- return eg:IsExists(c99999934.limfilter,1,nil,tp) 
-- end
-- function c99999934.limop(e,tp,eg,ep,ev,re,r,rp)
	-- if Duel.GetCurrentChain()==0 then
		-- Duel.SetChainLimitTillChainEnd(c99999934.chainlm)
	-- else
		-- e:GetHandler():RegisterFlagEffect(99999934,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	-- end
-- end
-- function c99999934.chainlm(e,rp,tp)
	-- return tp==rp 
-- end
-- function c99999934.aclimit(e,re,tp)
	-- return not re:GetHandler():IsImmuneToEffect(e)
-- end
-- function c99999934.actcon(e)
	-- local a=Duel.GetAttacker()
	-- local d=Duel.GetAttackTarget()
	-- return ( a and a:IsControler(e:GetHandlerPlayer()) and (a:IsSetCard(0x2e0) or a:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)))
	 -- or (d and d:IsControler(e:GetHandlerPlayer()) and  (d:IsSetCard(0x2e0) or d:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)))
-- end
-- function c99999934.limop2(e,tp,eg,ep,ev,re,r,rp)
	-- if  e:GetHandler():GetFlagEffect(99999934)~=0 then
		-- Duel.SetChainLimitTillChainEnd(c99999934.chainlm)
	-- end
	-- e:GetHandler():ResetFlagEffect(99999934)
-- end
function c99999934.effcon(e,tp,eg,ep,ev,re,r,rp)
	return (r==REASON_XYZ or r==REASON_SYNCHRO  or r==REASON_FUSION) and (e:GetHandler():GetReasonCard():IsSetCard(0x2e0) 
	or e:GetHandler():GetReasonCard():IsSetCard(0x2e1)  or e:GetHandler():GetReasonCard():IsSetCard(0x2e7))
end
function c99999934.effop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetOperation(c99999934.sumop)
	rc:RegisterEffect(e1)
end
function c99999934.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c99999934.chainlm)
end
function c99999934.chainlm(e,rp,tp)
	return tp==rp
end
function c99999934.effop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
