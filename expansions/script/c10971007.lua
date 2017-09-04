--玄灵龙 雷轰
function c10971007.initial_effect(c)
	c:SetSPSummonOnce(10971007)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10971007.spcon)
	c:RegisterEffect(e1) 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10971007)
	e5:SetCost(c10971007.excost)
	e5:SetTarget(c10971007.sptg)
	e5:SetOperation(c10971007.spop)
	c:RegisterEffect(e5)   
end
function c10971007.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x234) and not c:IsRace(RACE_DRAGON)
end
function c10971007.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10971007.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10971007.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c10971007.spfilter(c,e,tp)
	return (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_THUNDER)) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971007.spfilter2(c,e,tp)
	return c:IsSetCard(0x234) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10971007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c10971007.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp) 
		or (Duel.IsPlayerAffectedByEffect(tp,10971000) and Duel.IsExistingMatchingCard(c10971007.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp)) ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10971007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10971007.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c10971007.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,10971000)
	then g:Merge(g2) end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
