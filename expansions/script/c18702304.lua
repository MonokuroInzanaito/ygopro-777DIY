--神操鸟 森极
function c18702304.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	c:EnableReviveLimit()
	--SEARCH
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(73176465,0))
	--e1:SetCategory(CATEGORY_RECOVER)
	--e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e1:SetCode(EVENT_TO_GRAVE)
	--e1:SetCondition(c18702304.con)
	--e1:SetTarget(c18702304.target)
	--e1:SetOperation(c18702304.operation)
	--c:RegisterEffect(e1)
	--direct
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(31437713,0))
	--e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e4:SetType(EFFECT_TYPE_QUICK_O)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetCountLimit(1)
	--e4:SetCode(EVENT_FREE_CHAIN)
	--e4:SetHintTiming(0,0x1e0)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetTarget(c18702304.target2)
	--e4:SetOperation(c18702304.operation2)
	--c:RegisterEffect(e4)
	--Destroy replace
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(18702304,0))
	--e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	--e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EFFECT_DESTROY_REPLACE)
	--e3:SetTarget(c18702304.desreptg)
	--c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28637168,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c18702304.target22)
	e1:SetOperation(c18702304.operation22)
	c:RegisterEffect(e1)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13959634,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c18702304.discon)
	e3:SetTarget(c18702304.distg)
	e3:SetOperation(c18702304.disop)
	c:RegisterEffect(e3)
end
function c18702304.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
		and re:GetHandler():IsSetCard(0x6ab2)
end
function c18702304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702304.filter,tp,LOCATION_GRAVE,0,1,nil,nil) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c18702304.filter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ev)
end
function c18702304.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c18702304.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6ab2)
end
function c18702304.filter2(c)
	return c:IsFaceup()
end
function c18702304.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c18702304.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c18702304.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c18702304.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84013237,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c18702304.descon)
	e1:SetTarget(c18702304.destg)
	e1:SetOperation(c18702304.desop)
	tc:RegisterEffect(e1,true)
	if not tc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
end
function c18702304.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttackTarget()==c
end
function c18702304.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c18702304.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c18702304.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c18702304.desrepfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	if Duel.SelectYesNo(tp,aux.Stringid(18755515,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c18702304.desrepfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c18702304.desrepfilter(c)
	return c:IsSetCard(0x6ab2)
end
function c18702304.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c18702304.filter7(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsSetCard(0x6ab2)
end
function c18702304.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c83764718.filter7(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18702304.filter7,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c18702304.filter7,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18702304.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetDescription(aux.Stringid(18702304,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(0x6ab2)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c18702304.filter22(c)
	return c:IsFaceup() and c:GetLevel()~=4
end
function c18702304.target22(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702304.filter22,tp,LOCATION_MZONE,0,1,nil) end
end
function c18702304.operation22(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18702304.filter22,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end