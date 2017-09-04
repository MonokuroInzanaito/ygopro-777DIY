--死讯的替代
function c10982117.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10982117.destg)
	e2:SetValue(c10982117.value)
	e2:SetOperation(c10982117.desop)
	c:RegisterEffect(e2) 
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10982117,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetTarget(c10982117.target)
    e4:SetOperation(c10982117.activate)
    c:RegisterEffect(e4) 
end
function c10982117.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c10982117.repfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToGrave()
end
function c10982117.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10982117)==0 and eg:IsExists(c10982117.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c10982117.repfilter,tp,LOCATION_DECK,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(10982117,0))
end
function c10982117.value(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c10982117.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10982117.repfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,10982117,RESET_PHASE+PHASE_END,0,1)
end
function c10982117.filter(c)
    return c:IsFaceup()
end
function c10982117.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10982117.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c10982117.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tg=g:GetMinGroup(Card.GetAttack)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c10982117.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c10982117.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tg=g:GetMinGroup(Card.GetAttack)
        if tg:GetCount()>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=tg:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        else Duel.Destroy(tg,REASON_EFFECT) end
    end
end