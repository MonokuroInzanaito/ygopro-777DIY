--跃入极光 哲尔尼亚斯
function c60159014.initial_effect(c)
	--synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c60159014.mfilter),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60159014)
	e1:SetCost(c60159014.cost)
    e1:SetTarget(c60159014.target)
    e1:SetOperation(c60159014.activate)
    c:RegisterEffect(e1)
	--destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60159014,0))
    e4:SetCategory(CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,6019014)
    e4:SetTarget(c60159014.destg)
    e4:SetOperation(c60159014.desop)
    c:RegisterEffect(e4)
	--indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c60159014.imtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
function c60159014.mfilter(c)
    return (c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))
end
function c60159014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60159014.filter(c)
    return ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and c:IsAbleToHand()
end
function c60159014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c60159014.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60159014.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c60159014.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60159014.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
function c60159014.filter2(c)
    return c:IsFaceup()
end
function c60159014.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159014.filter2,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c60159014.filter2,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c60159014.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60159014,1))
    local g=Duel.SelectMatchingCard(tp,c60159014.filter2,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local tc=g:GetFirst()
        local opt=Duel.SelectOption(tp,aux.Stringid(60159014,2),aux.Stringid(60159014,3)) 
		if opt==0 then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		else
			Duel.Recover(tp,tc:GetDefense(),REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
    end
end
function c60159014.imtg(e,c,re,rp)
    return ((c:IsSetCard(0x5b24) or c:IsSetCard(0x6b24)) or (c:IsSetCard(0x9b24) or c:IsSetCard(0xab24))) and not c:IsCode(60159014) and rp~=e:GetHandlerPlayer()
end