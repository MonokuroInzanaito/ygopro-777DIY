--青与赤的螺旋舞 Xer＆Yvel
function c60159017.initial_effect(c)
	c:SetUniqueOnField(1,0,60159017)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60159017.spcon)
	e2:SetOperation(c60159017.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60159017,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c60159017.sptg)
	e3:SetOperation(c60159017.spop2)
	c:RegisterEffect(e3)
	--Attribute Dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--Attribute Dark
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_ADD_RACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c60159017.effcon3)
	e6:SetOperation(c60159017.spop3)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_RECOVER)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c60159017.effcon4)
	e7:SetOperation(c60159017.spop4)
	c:RegisterEffect(e7)
	--immune
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(aux.TargetBoolFunction(c60159017.pfilter))
	e8:SetValue(c60159017.efilter)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(aux.TargetBoolFunction(c60159017.pfilter))
	e9:SetValue(c60159017.tgvalue)
	c:RegisterEffect(e9)
end
function c60159017.spfilter1(c,tp,fc)
	return c:IsSetCard(0x6b24) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c60159017.spfilter2,1,c,fc)
end
function c60159017.pfilter(c)
	return (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24))
end
function c60159017.spfilter2(c,fc)
	return c:IsSetCard(0xab24) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsCanBeFusionMaterial(fc)
end
function c60159017.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c60159017.spfilter1,1,nil,tp,c)
end
function c60159017.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c60159017.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c60159017.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	local tc2=g1:GetFirst()
	while tc2 do
		if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
		tc2=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c60159017.filter(c,e,tp)
	return ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c60159017.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60159017.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60159017.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60159017.spfilter(c)
	return true
end
function c60159017.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			if tc:IsType(TYPE_XYZ) then
				local g=Duel.GetMatchingGroup(c60159017.spfilter,tp,LOCATION_HAND,0,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159017,1)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159017,2))
					local sg=g:Select(tp,1,1,nil)
					Duel.Overlay(tc,sg)
				end
			end
		end
	end
end
function c60159017.thcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return phase==PHASE_STANDBY
end
function c60159017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local opt=Duel.SelectOption(tp,aux.Stringid(60159017,4),aux.Stringid(60159017,5))
	e:SetLabel(opt)
end
function c60159017.effcon3(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0
end
function c60159017.spop3(e,tp,eg,ep,ev,re,r,rp)
	if ev~=0 then
		Duel.Hint(HINT_CARD,0,60159017)
		local g=Duel.GetLP(tp)
		Duel.SetLP(tp,g+ev)
	end
end
function c60159017.effcon4(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c60159017.spop4(e,tp,eg,ep,ev,re,r,rp)
	if ev~=0 then
		Duel.Hint(HINT_CARD,0,60159017)
		local g=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,g-ev)
	end
end
function c60159017.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c60159017.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end