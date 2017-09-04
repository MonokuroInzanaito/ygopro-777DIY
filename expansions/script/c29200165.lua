--凋叶棕-改-Mad Party
function c29200165.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c29200165.mfilter,8,2,c29200165.ovfilter,aux.Stringid(29200165,0),2,c29200165.xyzop)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29200165,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c29200165.atkcost)
    e1:SetOperation(c29200165.atkop)
    c:RegisterEffect(e1)
    --to defense
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c29200165.poscon)
    e2:SetOperation(c29200165.posop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200165,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c29200165.thtg)
    e3:SetOperation(c29200165.thop)
    c:RegisterEffect(e3)
end
function c29200165.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if ct==1 then 
        Duel.DiscardDeck(tp,1,REASON_COST)
        e:SetLabel(1)
    else
        local ac=0
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29200165,2))
        if ct==2 then ac=Duel.AnnounceNumber(tp,2,1)
        else ac=Duel.AnnounceNumber(tp,3,2,1) end
        Duel.DiscardDeck(tp,ac,REASON_COST)
        e:SetLabel(ac)
    end
end
function c29200165.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local ct=e:GetLabel()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        e1:SetValue(ct*400)
        c:RegisterEffect(e1)
    end
end
function c29200165.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0
end
function c29200165.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c29200165.filter(c)
    return c:IsSetCard(0x53e0) and c:IsAbleToHand()
end
function c29200165.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29200165.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29200165.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c29200165.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29200165.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
function c29200165.mfilter(c)
    return c:IsSetCard(0x53e0) 
end
function c29200165.ovfilter(c)
    return c:IsFaceup() and c:IsCode(29200134)
end
function c29200165.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,29200165)==0 end
    Duel.RegisterFlagEffect(tp,29200165,RESET_PHASE+PHASE_END,0,1)
end
