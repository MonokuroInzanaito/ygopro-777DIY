--罪之名
function c60158610.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,60158610+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60158610.condition)
    e1:SetTarget(c60158610.target)
    e1:SetOperation(c60158610.activate)
    c:RegisterEffect(e1)
end
function c60158610.conditionfilter(c)
    return not (c:IsRace(RACE_FIEND) and c:IsFaceup())
end
function c60158610.condition(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroupCount(c60158610.conditionfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and sg==0
end
function c60158610.filter(c,e,tp)
	local att=c:GetAttribute()
	if c:IsType(TYPE_XYZ) then
		local rk=c:GetRank()
		return c:IsFaceup() and rk>0 and Duel.IsExistingMatchingCard(c60158610.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk,c,att)
	else
		local lv=c:GetLevel()
		return c:IsFaceup() and lv>0 and Duel.IsExistingMatchingCard(c60158610.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,c,att)
	end
end
function c60158610.filter2(c,e,tp,rl,mc,att)
    return c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ) and c:GetRank()==rl and c:IsAttribute(att) and mc:IsCanBeXyzMaterial(c) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c60158610.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c60158610.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c60158610.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60158610.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    local att=tc:GetAttribute()
	if tc:IsType(TYPE_XYZ) then
		local rk=tc:GetRank()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60158610.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk,tc,att)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	else
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60158610.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,tc,att)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
