--阿莱克涅
function c10981082.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10981082.spcon)
	e2:SetOperation(c10981082.spop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c10981082.limcon)
	e3:SetValue(c10981082.aclimit)
	c:RegisterEffect(e3)   
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(10981082,1))
    e5:SetCategory(CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c10981082.limcon)
    e5:SetTarget(c10981082.tgtg)
    e5:SetOperation(c10981082.tgop)
    c:RegisterEffect(e5)
end
function c10981082.filter(c)
	return c:GetLevel()==8 and not c:IsSummonableCard() and c:IsAbleToGraveAsCost()
end
function c10981082.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10981082.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c10981082.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10981082.filter,c:GetControler(),LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10981082.confilter(c)
	return c:IsRace(RACE_INSECT)
end
function c10981082.limcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	return Duel.IsExistingMatchingCard(c10981082.confilter,tp,LOCATION_GRAVE,0,1,nil)
		and g:GetClassCount(Card.GetCode)==g:GetCount() 
end
function c10981082.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not (re:GetHandler():IsImmuneToEffect(e) or re:GetHandler():GetLevel()==8)
end
function c10981082.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
end
function c10981082.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
        local sg=g:Select(1-tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.SendtoGrave(sg,REASON_RULE)
    end
end

