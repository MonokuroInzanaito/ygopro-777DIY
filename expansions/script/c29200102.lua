--凋叶棕-为什么
function c29200102.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x53e0),aux.NonTuner(Card.IsSetCard,0x53e0),1)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetTarget(c29200102.attg)
    e1:SetOperation(c29200102.atop)
    c:RegisterEffect(e1)
    --negate attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29200102,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c29200102.condition)
    e3:SetTarget(c29200102.attg)
    e3:SetOperation(c29200102.operation)
    c:RegisterEffect(e3)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200102,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_BECOME_TARGET)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c29200102.condition1)
    e2:SetTarget(c29200102.negtg)
    e2:SetOperation(c29200102.operation1)
    c:RegisterEffect(e2)
end
function c29200102.attg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c29200102.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(tp,70,71,72)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(3000)
            e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
            c:RegisterEffect(e1)
        end
    end
    Duel.BreakEffect()
    Duel.MoveSequence(tc,1)
    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
end
function c29200102.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=eg:GetFirst()
    return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x53e0)
end
function c29200102.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(tp,70,71,72)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
        Duel.NegateAttack()
        Duel.Damage(1-tp,500,REASON_EFFECT)
    end
    Duel.BreakEffect()
    Duel.MoveSequence(tc,1)
    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
end
function c29200102.negfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x53e0) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c29200102.condition1(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c29200102.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c29200102.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    --[[if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end]]
end
function c29200102.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(tp,70,71,72)
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if (op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (op==2 and tc:IsType(TYPE_TRAP)) then
        --[[Duel.NegateActivation(ev)
        if re:GetHandler():IsRelateToEffect(re) then
            Duel.Destroy(eg,REASON_EFFECT)
        end]]
        if Duel.NegateEffect(ev) then
     		Duel.Damage(1-tp,500,REASON_EFFECT)
        end
    end
    Duel.BreakEffect()
    Duel.MoveSequence(tc,1)
    Duel.RaiseSingleEvent(tc,29200000,e,0,0,0,0)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+29200001,e,0,tp,0,0)
end
