--First Folio
function c99998993.initial_effect(c)
	c:SetUniqueOnField(1,0,99998993)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99998993.target)
	e1:SetOperation(c99998993.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c99998993.eqlimit)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c99998993.destg)
	e3:SetValue(c99998993.value)
	e3:SetOperation(c99998993.desop)
	c:RegisterEffect(e3)
	--[[--国王剧团
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0)
	e4:SetCountLimit(1)
	e4:SetTarget(c99998993.tg)
	e4:SetOperation(c99998993.op)
	c:RegisterEffect(e4)--]]
end
function c99998993.eqlimit(e,c)
	return  c:IsCode(99998994)
end
function c99998993.filter(c)
	return c:IsFaceup() and c:IsCode(99998994)  
end
function c99998993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c99998993.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99998993.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99998993.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99998993.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c99998993.dfilter(c)
	return  c:IsReason(REASON_BATTLE)
end
function c99998993.repfilter(c)
	return  c:IsAbleToGrave()
end
function c99998993.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c99998993.dfilter,1,nil)
		and Duel.IsExistingMatchingCard(c99998993.repfilter,tp,LOCATION_HAND,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(99991097,6))
end
function c99998993.value(e,c)
	return  c:IsReason(REASON_BATTLE)
end
function c99998993.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99998993.repfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c99998993.cfilter(c,tp)
    local lv
	if c:GetLevel()>0 then
    lv=c:GetLevel()
	else
	lv=c:GetRank()
	end
	return c:IsFaceup()  
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99998987,0,0x4011,c:GetAttack(),c:GetDefense(),lv,c:GetRace(),c:GetAttribute())
end
function c99998993.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  and c99998993.cfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsExistingTarget(c99998993.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c99998993.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99998993.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    local lv
	if tc:GetLevel()>0 then
    lv=tc:GetLevel()
	else
	lv=tc:GetRank()
	end
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99998987,0,0x4011,tc:GetAttack(),tc:GetDefense(),
			lv,tc:GetRace(),tc:GetAttribute()) then return end
	local token=Duel.CreateToken(tp,99998987)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UNRELEASABLE_SUM)
	e6:SetValue(1)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e7)
	local e8=Effect.CreateEffect(e:GetHandler())
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e8:SetValue(1)
	e8:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e8)
	local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e9:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetLabel(tc:GetRealFieldID())
	e9:SetTarget(c99998993.atktg)
	e9:SetValue(1)
	token:RegisterEffect(e9)
	local code=tc:GetOriginalCode()
	token:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e11:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e11)
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_ADD_CODE)
	e12:SetValue(tc:GetCode())
	e12:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e12)
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetRange(LOCATION_MZONE)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetCountLimit(1)
	de:SetOperation(c99998993.op2)
	de:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(de)
	Duel.SpecialSummonComplete()
end
function c99998993.atktg(e)
	return not e:GetHandler()
end
function c99998993.val(e,c)
	return  c:GetRealFieldID()~=e:GetLabel()
end
function c99998993.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end