--绝灭天使 鸢一折纸
function c18706047.initial_effect(c)
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
	e2:SetCondition(c18706047.sprcon)
	e2:SetOperation(c18706047.sprop)
	c:RegisterEffect(e2)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c18706047.condition)
	e1:SetTarget(c18706047.target)
	e1:SetOperation(c18706047.operation)
	c:RegisterEffect(e1)
end
function c18706047.sprfilter1(c,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xabb) and c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c18706047.sprfilter2,tp,LOCATION_MZONE,0,1,c,lv)
end
function c18706047.sprfilter2(c,lv)
	return c:IsSetCard(0xabb) and c:IsFaceup() and c:GetLevel()==lv and c:IsType(TYPE_TUNER) and c:IsReleasable()
end
function c18706047.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c18706047.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c18706047.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c18706047.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local sc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c18706047.sprfilter2,tp,LOCATION_MZONE,0,1,1,sc,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c18706047.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsSetCard(0xabb)
end
function c18706047.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18706047.cfilter,1,nil,tp)
end
function c18706047.spfilter(c,e,tp)
	return c:IsCode(18706046) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c18706047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c18706047.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c18706047.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c18706047.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=tc:GetFirst()
	if sc then
		local cg=Group.FromCards(c)
		sc:SetMaterial(cg)
		Duel.Overlay(sc,cg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end