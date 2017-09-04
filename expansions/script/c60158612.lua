--魂与血的二重螺旋
function c60158612.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60158612,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c60158612.target1)
    e1:SetOperation(c60158612.activate1)
    c:RegisterEffect(e1)
	--draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60158612,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,60158612)
    e2:SetCondition(c60158612.condition2)
    e2:SetTarget(c60158612.target2)
    e2:SetOperation(c60158612.operation2)
    c:RegisterEffect(e2)
	--fusion
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158612,4))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(c60158612.target3)
    e3:SetOperation(c60158612.operation3)
    c:RegisterEffect(e3)
end
function c60158612.spfilter(c,e,tp)
    return c:IsSetCard(0xab28) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158612.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158612.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60158612.activate1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60158612.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60158612.afilter(c,tp)
    return c:IsRace(RACE_FIEND) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c60158612.condition2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60158612.afilter,1,nil,tp)
end
function c60158612.afilter2(c)
    return c:IsSetCard(0xab28) and c:IsType(TYPE_MONSTER)
end
function c60158612.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158612.afilter2,tp,LOCATION_DECK,0,1,nil) end
end
function c60158612.operation2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local a=eg:Filter(c60158612.afilter,nil,tp)
	if a:GetCount()==1 then
		local tc=a:GetFirst()
		if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158612,2))
			local g=Duel.SelectMatchingCard(tp,c60158612.afilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Overlay(tc,g)
			end
		end
	else
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158612,3))
        local sg=a:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158612,2))
			local g=Duel.SelectMatchingCard(tp,c60158612.afilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Overlay(tc,g)
			end
		end
	end
end
function c60158612.filter1(c,e)
    return not c:IsImmuneToEffect(e)
end
function c60158612.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c60158612.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
        local mg1=Duel.GetFusionMaterial(tp)
        local res=Duel.IsExistingMatchingCard(c60158612.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c60158612.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60158612.operation3(e,tp,eg,ep,ev,re,r,rp)
    local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c60158612.filter1,nil,e)
    local sg1=Duel.GetMatchingGroup(c60158612.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c60158612.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            tc:SetMaterial(mat1)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
