--超未来超量
function c11113093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113093+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11113093.target)
	e1:SetOperation(c11113093.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetOperation(c11113093.desop)
	c:RegisterEffect(e2)
end
function c11113093.mfilter(c)
	return ((c:IsLocation(LOCATION_HAND) and c:IsPublic()) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c11113093.spfilter(c,mg)
    if Duel.IsExistingMatchingCard(c11113093.hgfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,1,nil) then
	    return c:IsType(TYPE_XYZ) and c:IsAbleToChangeControler()
	else	
		return c:IsXyzSummonable(mg) and mg:IsExists(c11113093.cfilter,1,nil,c) and c:IsAbleToChangeControler()
	end
end
function c11113093.hgfilter(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or c:IsFacedown()
end
function c11113093.cfilter(c,mc)
	return c:IsCanBeXyzMaterial(mc)
end
function c11113093.mfilter1(c,tc)
	return c:IsCanBeXyzMaterial(tc) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c11113093.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local mg=Duel.GetMatchingGroup(c11113093.mfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11113093.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11113093.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,g)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11113093.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc then
	    local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
		local ct=conf:GetCount()
		if ct>0 then
			Duel.ConfirmCards(tp,conf)
			local g=conf:Filter(c11113093.mfilter1,nil,tc)
			if g:GetCount()>0 and tc:IsXyzSummonable(g) and not tc:IsSetCard(0x221) then
			    Duel.XyzSummon(tp,tc,g,1,ct)
				Duel.BreakEffect()
				Duel.GetControl(tc,1-tp)
				c:SetCardTarget(tc)
			end
            Duel.ShuffleHand(1-tp)			
		end
	end
end
function c11113093.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end