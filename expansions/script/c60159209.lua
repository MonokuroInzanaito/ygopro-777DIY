--澄 夕靥
function c60159209.initial_effect(c)
	--only 1 can exists
    local e21=Effect.CreateEffect(c)
    e21:SetType(EFFECT_TYPE_SINGLE)
    e21:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    e21:SetCondition(c60159209.excon)
    c:RegisterEffect(e21)
    local e31=e21:Clone()
    e31:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e31)
    local e41=Effect.CreateEffect(c)
    e41:SetType(EFFECT_TYPE_FIELD)
    e41:SetRange(LOCATION_MZONE)
    e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e41:SetTargetRange(1,0)
    e41:SetCode(EFFECT_CANNOT_SUMMON)
    e41:SetTarget(c60159209.sumlimit)
    c:RegisterEffect(e41)
    local e51=e41:Clone()
    e51:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e51)
    local e61=e41:Clone()
    e61:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e61)
	local e81=Effect.CreateEffect(c)
    e81:SetType(EFFECT_TYPE_FIELD)
    e81:SetCode(EFFECT_SELF_DESTROY)
    e81:SetRange(LOCATION_MZONE)
    e81:SetTargetRange(LOCATION_MZONE,0)
    e81:SetTarget(c60159209.destarget)
    c:RegisterEffect(e81)
	--synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5b25),aux.NonTuner(Card.IsSetCard,0x5b25),1)
    c:EnableReviveLimit()
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c60159209.value)
    c:RegisterEffect(e3)
	
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60159209)
	e1:SetCost(c60159209.cost)
    e1:SetTarget(c60159209.target)
    e1:SetOperation(c60159209.activate)
    c:RegisterEffect(e1)
	--search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60159209,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,6019209)
    e2:SetCondition(c60159209.condition)
    e2:SetTarget(c60159209.target2)
    e2:SetOperation(c60159209.operation)
    c:RegisterEffect(e2)
end
function c60159209.sumlimit(e,c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_SYNCHRO)
end
function c60159209.exfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5b25) and c:IsType(TYPE_SYNCHRO)
end
function c60159209.excon(e,tp)
    return Duel.IsExistingMatchingCard(c60159209.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60159209.destarget(e,c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_SYNCHRO) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c60159209.filter(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c60159209.value(e,c,tp)
    return Duel.GetMatchingGroupCount(c60159209.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)*100
end
function c60159209.costfilter(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c60159209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159209.costfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159209.costfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60159209.filter2(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60159209.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159209.filter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60159209.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159209.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60159209.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159209.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159209.filter3,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60159209.filter3(c)
    return c:IsSetCard(0x5b25) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60159209.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60159209.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
