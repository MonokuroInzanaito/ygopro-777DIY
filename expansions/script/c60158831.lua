--红色骑士团·不可思议之国
function c60158831.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60158831+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c60158831.activate)
    c:RegisterEffect(e1)
	--atkup
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetOperation(c60158831.atkop)
    c:RegisterEffect(e2)
	--atk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60158831,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_CONTROL)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,6018831)
    e3:SetCondition(c60158831.con)
    e3:SetTarget(c60158831.tg)
    e3:SetOperation(c60158831.op)
    c:RegisterEffect(e3)
end
function c60158831.filter(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60158831.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c60158831.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60158831,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c60158831.afilter(c,re,tp)
    return c:IsSetCard(0x5b28) and c:IsReason(REASON_COST) and c:IsControler(tp) and re:IsHasType(0x7f0)
end
function c60158831.atkop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(c60158831.afilter,nil,re,tp)
    if ct>0 then
        local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x5b28)
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(150)
				sc:RegisterEffect(e1)
				sc=g:GetNext()
			end
		end
    end
end
function c60158831.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
end
function c60158831.filter2(c)
    return c:IsSetCard(0x5b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60158831.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c60158831.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c60158831.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60158831.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end
