--八枢罪 安眠
function c60159108.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,60159108)
    e1:SetTarget(c60159108.target)
    e1:SetOperation(c60159108.activate)
    c:RegisterEffect(e1)
	--Activate
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159101,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,60159108)
    e2:SetCondition(c60159108.condition)
    e2:SetTarget(c60159108.settg)
    e2:SetOperation(c60159108.setop)
    c:RegisterEffect(e2)
end
function c60159108.filter(c)
    return c:IsSetCard(0x3b25) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
end
function c60159108.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159108.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c60159108.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,c60159108.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159108,0))
		e:SetLabel(Duel.SelectOption(tp,70,71,72))
		local tc=g:GetFirst()
		local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_IMMUNE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        if e:GetLabel()==0 then
			e2:SetValue(c60159108.efilter1)
		elseif e:GetLabel()==1 then
			e2:SetValue(c60159108.efilter2)
		else e2:SetValue(c60159108.efilter3) end
        tc:RegisterEffect(e2)
    end
end
function c60159108.efilter1(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c60159108.efilter2(e,te)
    return te:IsActiveType(TYPE_SPELL) and te:GetOwner()~=e:GetOwner()
end
function c60159108.efilter3(e,te)
    return te:IsActiveType(TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
function c60159108.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ and eg:GetFirst():IsControler(tp) 
		and eg:GetFirst():IsSetCard(0x3b25) and eg:GetFirst():IsType(TYPE_MONSTER)
end
function c60159108.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c60159108.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsSSetable() then
        Duel.SSet(tp,c)
        Duel.ConfirmCards(1-tp,c)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end