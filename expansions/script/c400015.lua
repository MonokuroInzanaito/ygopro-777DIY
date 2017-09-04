--Is The Order A Rabbit?
function c400015.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(400015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(3,400015+EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c400015.spcost)
	e1:SetTarget(c400015.sptg)
	e1:SetOperation(c400015.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(400015,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(3,400015+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c400015.cost)
	e2:SetTarget(c400015.target)
	e2:SetOperation(c400015.operation)
	c:RegisterEffect(e2)
end
function c400015.cfilter2(c)
	return (c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()) or (c:IsFaceup() and c:IsAbleToGraveAsCost())
end
function c400015.spfilter(c,e,tp,race,att,lv)
	return c:GetOriginalRace()==race and c:GetOriginalAttribute()==att and (c:GetLevel()==lv+1 or c:GetLevel()==lv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c400015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_ONFIELD) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c400015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetLabelObject()
	local race,att,lv=tc:GetOriginalRace(),tc:GetOriginalAttribute(),tc:GetLevel()
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT) and not tc:IsType(TYPE_XYZ) then
	   local g=Duel.GetMatchingGroup(c400015.spfilter,tp,LOCATION_DECK,0,nil,e,tp,race,att,lv)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(400015,2)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=g:Select(tp,1,1,nil)
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
function c400015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c400015.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(400015,3))
	local tc=Duel.SelectMatchingCard(tp,c400015.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_EXTRA) then
	   Duel.SendtoGrave(tc,REASON_COST)
	else
	   Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
	e:SetLabelObject(tc)
end
function c400015.cfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsAbleToExtraAsCost()
end
function c400015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c400015.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c400015.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c400015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c400015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end