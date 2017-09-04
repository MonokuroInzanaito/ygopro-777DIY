--与死亡的第一次接触
function c60159025.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60159025+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60159025.condition)
	e1:SetCost(c60159025.cost1)
    e1:SetTarget(c60159025.target)
    e1:SetOperation(c60159025.operation)
    c:RegisterEffect(e1)
	--draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c60159025.drcon)
    e2:SetTarget(c60159025.drtg)
    e2:SetOperation(c60159025.drop)
    c:RegisterEffect(e2)
end
function c60159025.cfilter(c,tp)
    return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
        and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24))
end
function c60159025.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60159025.cfilter,1,nil,tp)
end
function c60159025.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,2000)
    else Duel.PayLPCost(tp,2000) end
end
function c60159025.spfilter(c,e,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159025.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=eg:FilterCount(c60159025.spfilter,nil,e,tp)
        return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
    end
    Duel.SetTargetCard(eg)
    local g=eg:Filter(c60159025.spfilter,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c60159025.spfilter2(c,e,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRelateToEffect(e) and (c:IsSetCard(0x6b24) or c:IsSetCard(0xab24)) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60159025.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local sg=eg:Filter(c60159025.spfilter2,nil,e,tp)
    if ft<sg:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg2=sg:Select(tp,1,1,nil) 
	Duel.HintSelection(sg2)
    if Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local tc=sg2:GetFirst()
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		if atk>def then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		else
			Duel.Damage(1-tp,def,REASON_EFFECT)
		end
		if tc:IsType(TYPE_XYZ) then
			e:GetHandler():CancelToGrave()
			Duel.Overlay(tc,e:GetHandler())
		end
	end
end
function c60159025.drcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_DESTROY)~=0 and rp~=tp and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c60159025.sfilter(c)
    return c:IsAbleToGrave()
end
function c60159025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159025.sfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c60159025.sfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60159025.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159025.sfilter,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end