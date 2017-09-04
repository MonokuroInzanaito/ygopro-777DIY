--星刻*拉寇尔四世
function c602306.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)
	--add P summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c602306.spcon)
	e1:SetOperation(c602306.spop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,602300)
	e2:SetCondition(c602306.spcon1)
	e2:SetOperation(c602306.spop1)
	c:RegisterEffect(e2)

	--change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(602306,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,602306)
	e6:SetCost(c602306.cost)
	e6:SetCondition(c602306.condition)
	e6:SetOperation(c602306.operation)
	c:RegisterEffect(e6)
	--change2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(602306,0))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,0x1c0+TIMING_BATTLE_PHASE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,602306)
	e7:SetCost(c602306.cost)
	e7:SetCondition(c602306.condition2)
	e7:SetOperation(c602306.operation)
	c:RegisterEffect(e7)
end

function c602306.pcfilter(c)
	return c:IsSetCard(0x42c) and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsType(TYPE_PENDULUM)
end

function c602306.filter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return c:IsLocation(LOCATION_REMOVED) and lv>=lscale and lv<=rscale 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden() and c:IsSetCard(0x42c)
end

function c602306.spcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 and not (lscale==1 and rscale==1 and Duel.IsExistingMatchingCard(c602306.pcfilter,tp,LOCATION_SZONE,0,2,nil)) then return false end
	if og then
		return og:IsExists(c602306.filter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c602306.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lscale,rscale)
	end
end

function c602306.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>3 then ft=3 end
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c602306.filter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c602306.filter,tp,LOCATION_REMOVED,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end

function c602306.spfilter1(c)
	return c:IsSetCard(0x42c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsCode(602306)
end

function c602306.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c602306.spfilter1,tp,LOCATION_DECK,0,1,nil)
end

function c602306.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c602306.spfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c602306.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	   Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end

function c602306.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(602301) and not c:IsDisabled()
end

function c602306.condition(e,c)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) 
	   and not Duel.IsExistingMatchingCard(c602306.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602306.condition2(e,c)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) 
	   and Duel.IsExistingMatchingCard(c602306.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602306.filter1(c)
	return c:IsSetCard(0x42c) and c:IsAbleToHand()
end

function c602306.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.ConfirmDecktop(tp,1)
	if tc:IsSetCard(0x42c) and tc:IsType(TYPE_MONSTER) then
		Duel.DisableShuffleCheck()
		if Duel.SelectYesNo(tp,aux.Stringid(602306,1)) 
		   and Duel.IsExistingMatchingCard(c602306.filter1,tp,LOCATION_DECK,0,1,nil) then
			local g2=Duel.SelectMatchingCard(tp,c602306.filter1,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end


