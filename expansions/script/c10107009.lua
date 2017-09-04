--安提抹杀者 腐朽天使
function c10107009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10107009.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10107009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10107009)
	e2:SetCondition(c10107009.xyzcon1)
	e2:SetCost(c10107009.xyzcost)
	e2:SetTarget(c10107009.xyztg)
	e2:SetOperation(c10107009.xyzop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c10107009.xyzcon2)
	c:RegisterEffect(e3)	
end
function c10107009.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10107009.xyzfilter2(c,mg)
	return c:IsXyzSummonable(mg) and c:IsType(TYPE_XYZ)
end 
function c10107009.xyzfilter1(c)
	return c:IsRace(RACE_FIEND+RACE_ZOMBIE) and c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c10107009.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		  local g=Duel.GetMatchingGroup(c10107009.xyzfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		  return Duel.IsExistingMatchingCard(c10107009.xyzfilter2,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10107009.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c10107009.xyzfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local xyzg=Duel.GetMatchingGroup(c10107009.xyzfilter2,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
	   Duel.XyzSummon(tp,xyz,g,1,10)
	end
end
function c10107009.xyzcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c10107009.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c10107009.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10107009.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c10107009.cfilter2(c)
	return c:IsSetCard(0x6338) and c:IsFaceup()
end
function c10107009.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c10107009.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10107009.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end