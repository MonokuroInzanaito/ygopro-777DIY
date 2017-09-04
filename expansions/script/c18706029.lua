--美女与野兽
function c18706029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18706029+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c18706029.cost)
	e1:SetTarget(c18706029.target)
	e1:SetOperation(c18706029.activate)
	c:RegisterEffect(e1)
end
function c18706029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c18706029.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0xabb) and c:GetLevel()<=4 and Duel.IsExistingMatchingCard(c18706029.spfilter,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp)
end
function c18706029.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and (c:IsRace(RACE_BEASTWARRIOR) or c:IsRace(RACE_BEAST)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18706029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c18706029.cfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c18706029.cfilter,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18706029.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18706029.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local lp=Duel.GetLP(tp)
	if lp<=lv*200 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-lv*200)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c18706029.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c18706029.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()==RACE_WARRIOR or c:GetRace()==RACE_SPELLCASTER or c:GetRace()==RACE_ZOMBIE or c:GetRace()==RACE_MACHINE
	or c:GetRace()==RACE_AQUA or c:GetRace()==RACE_PYRO or c:GetRace()==RACE_ROCK or c:GetRace()==RACE_WINDBEAST
	or c:GetRace()==RACE_PLANT or c:GetRace()==RACE_INSECT or c:GetRace()==RACE_THUNDER or c:GetRace()==RACE_DRAGON
	  or c:GetRace()==RACE_FAIRY or c:GetRace()==RACE_FIEND or c:GetRace()==RACE_DINOSAUR or c:GetRace()==RACE_FISH
	  or c:GetRace()==RACE_SEASERPENT  or c:GetRace()==RACE_REPTILE  or c:GetRace()==RACE_PSYCHO  or c:GetRace()==RACE_DEVINE
	  or c:GetRace()==RACE_CREATORGOD  or c:GetRace()==RACE_WYRM
end