--现世的生命 哲尔尼亚斯
function c60159010.initial_effect(c)
	c:SetUniqueOnField(1,1,60159010)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(c60159010.mfilter),4,2)
    c:EnableReviveLimit()
	--to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159010,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c60159010.thcon)
    e1:SetCost(c60159010.thcost)
    e1:SetTarget(c60159010.thtg)
    e1:SetOperation(c60159010.thop)
    c:RegisterEffect(e1)
	--to grave
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCondition(c60159010.condition)
    e2:SetOperation(c60159010.operation)
    c:RegisterEffect(e2)
	--indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function c60159010.mfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159010.thcon(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    return phase==PHASE_END
end
function c60159010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60159010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
end
function c60159010.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*500,REASON_EFFECT)
end
function c60159010.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60159010.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c60159010.thcon2)
    e1:SetOperation(c60159010.thop2)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60159010.thfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60159010.thcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60159010.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c60159010.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60159010)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159010,5))
    local g=Duel.SelectMatchingCard(tp,c60159010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end