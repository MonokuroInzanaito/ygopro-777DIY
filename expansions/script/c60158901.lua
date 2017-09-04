--恶魔之间的交流方式
function c60158901.initial_effect(c)
	c:SetUniqueOnField(1,0,60158901)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c60158901.sptg)
    e2:SetOperation(c60158901.spop)
    c:RegisterEffect(e2)
end
function c60158901.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ)
end
function c60158901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158901.filter,tp,LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.GetMatchingGroup(c60158901.filter,tp,LOCATION_ONFIELD,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c60158901.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():GetFlagEffect(60158901)~=0 then 
		e:GetHandler():ResetFlagEffect(60158901)
		e:GetHandler():ResetFlagEffect(60158902)
		e:GetHandler():ResetFlagEffect(60158903)
		e:GetHandler():ResetFlagEffect(60158904)
		e:GetHandler():ResetFlagEffect(60158905)
		e:GetHandler():ResetFlagEffect(60158906)
		e:GetHandler():ResetFlagEffect(60158907)
		e:GetHandler():ResetFlagEffect(60158908)
	end
	Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60158901.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local tc=g:GetFirst()
		local rk=tc:GetRank()
		for i=1,rk do
			c:RegisterFlagEffect(60158901,RESET_EVENT+0x1fe0000,0,1)
		end
		if tc:IsAttribute(ATTRIBUTE_EARTH) then
			c:RegisterFlagEffect(60158902,RESET_EVENT+0x1fe0000,0,1)
		elseif tc:IsAttribute(ATTRIBUTE_WATER) then
			c:RegisterFlagEffect(60158903,RESET_EVENT+0x1fe0000,0,1)
		elseif tc:IsAttribute(ATTRIBUTE_FIRE) then
			c:RegisterFlagEffect(60158904,RESET_EVENT+0x1fe0000,0,1)
		elseif tc:IsAttribute(ATTRIBUTE_WIND) then
			c:RegisterFlagEffect(60158905,RESET_EVENT+0x1fe0000,0,1)
		elseif tc:IsAttribute(ATTRIBUTE_LIGHT) then
			c:RegisterFlagEffect(60158906,RESET_EVENT+0x1fe0000,0,1)
		elseif tc:IsAttribute(ATTRIBUTE_DARK) then
			c:RegisterFlagEffect(60158907,RESET_EVENT+0x1fe0000,0,1)
		elseif tc:IsAttribute(ATTRIBUTE_DEVINE) then
			c:RegisterFlagEffect(60158908,RESET_EVENT+0x1fe0000,0,1)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60158901,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c60158901.condition)
		e1:SetTarget(c60158901.thtg)
		e1:SetOperation(c60158901.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
    end
end
function c60158901.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c60158901.filter2(c,e,tp,rk)
    if e:GetHandler():GetFlagEffect(60158902)>0 then
		return not c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif e:GetHandler():GetFlagEffect(60158903)>0 then
		return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif e:GetHandler():GetFlagEffect(60158904)>0 then
		return not c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif e:GetHandler():GetFlagEffect(60158905)>0 then
		return not c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif e:GetHandler():GetFlagEffect(60158906)>0 then
		return not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif e:GetHandler():GetFlagEffect(60158907)>0 then
		return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	elseif e:GetHandler():GetFlagEffect(60158908)>0 then
		return not c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rk 
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function c60158901.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rk=e:GetHandler():GetFlagEffect(60158901)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60158901.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60158901.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local rk=e:GetHandler():GetFlagEffect(60158901)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158901.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60158903,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			if not tc:IsImmuneToEffect(e) then
				Duel.Overlay(c,sg)
			end
        end
    end
	e:GetHandler():ResetFlagEffect(60158901)
	e:GetHandler():ResetFlagEffect(60158902)
	e:GetHandler():ResetFlagEffect(60158903)
	e:GetHandler():ResetFlagEffect(60158904)
	e:GetHandler():ResetFlagEffect(60158905)
	e:GetHandler():ResetFlagEffect(60158906)
	e:GetHandler():ResetFlagEffect(60158907)
	e:GetHandler():ResetFlagEffect(60158908)
end