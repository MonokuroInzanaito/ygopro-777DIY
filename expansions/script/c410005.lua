--条河麻耶  by real_scl
function c410005.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c410005.splimit)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(410005,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c410005.efcost)
	e2:SetTarget(c410005.eftg)
	e2:SetOperation(c410005.efop)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(410005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c410005.spcost)
	e3:SetTarget(c410005.sptg)
	e3:SetOperation(c410005.spop)
	c:RegisterEffect(e3)
end
function c410005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c410005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   local g=c410005.check_function(e,tp,eg,ep,ev,re,r,rp,chk)
	   return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and g:GetCount()>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c410005.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=c410005.check_function(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if Duel.SpecialSummon(g,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)==2 then
	   local sxg=Duel.GetMatchingGroup(c410005.sxfilter,tp,LOCATION_EXTRA,0,nil,e,tp,sg)
	   if sxg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(410005,3)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local tc=sxg:Select(tp,1,1,nil):GetFirst()
				if tc:IsType(TYPE_SYNCHRO) then Duel.SynchroSummon(tp,tc,nil,sg)
				else
				   Duel.XyzSummon(tp,tc,sg,2,2)
				end
	   end
	end
end
function c410005.sxfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2) or c:IsSynchroSummonable(nil,mg)
end
function c410005.check_function(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 then return Group.CreateGroup() end
	local sc1=tc1:GetLeftScale()
	local sc2=tc2:GetRightScale()
	return Duel.GetMatchingGroup(c410005.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,sc1,sc2)
end
function c410005.spfilter(c,e,tp,sc1,sc2)
	local lv=0
	if c.pendulum_level then
	   lv=c.pendulum_level
	else
	   lv=c:GetLevel()
	end
	return c:IsLevelAbove(1) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and lv>sc1 and lv<sc2 and not c:IsForbidden() and c:IsRace(RACE_SPELLCASTER)
end
function c410005.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c410005.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c410005.tefilter,tp,LOCATION_DECK,0,1,nil) end
end
function c410005.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(410005,2))
	local g=Duel.SelectMatchingCard(tp,c410005.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
	   local te=tc[tc]
	   if not te then return end
	   local e1=Effect.CreateEffect(c)
	   e1:SetDescription(te:GetDescription())
	   e1:SetType(te:GetType())
	   e1:SetRange(LOCATION_PZONE)
	   e1:SetCode(te:GetCode())
	   if te:GetCost() then
		  e1:SetCost(te:GetCost())
	   end
	   if te:GetCondition() then
		  e1:SetCondition(te:GetCondition())
	   end
	   e1:SetTarget(te:GetTarget())
	   e1:SetOperation(te:GetOperation())
	   e1:SetCategory(te:GetCategory())
	   e1:SetProperty(te:GetProperty())
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	   c:RegisterEffect(e1)
	end
end
function c410005.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x42b) and not c:IsForbidden()
end
function c410005.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end