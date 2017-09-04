--凋叶棕-秘密俱乐部
function c29200117.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x53e0),aux.NonTuner(Card.IsSetCard,0x53e0),1)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200117,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c29200117.indcon)
    e2:SetTarget(c29200117.indtg)
    e2:SetOperation(c29200117.indop)
    c:RegisterEffect(e2)
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c29200117.pctg)
    e1:SetOperation(c29200117.pcop)
    c:RegisterEffect(e1)
    --discard deck
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(29200117,1))
    e12:SetCategory(CATEGORY_DECKDES)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e12:SetCode(EVENT_PHASE+PHASE_END)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCountLimit(1)
    e12:SetCondition(c29200117.discon)
    e12:SetTarget(c29200117.distg)
    e12:SetOperation(c29200117.disop)
    c:RegisterEffect(e12)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c29200117.pencon)
    e4:SetTarget(c29200117.pentg)
    e4:SetOperation(c29200117.penop)
    c:RegisterEffect(e4)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c29200117.destg)
    e3:SetOperation(c29200117.desop)
    c:RegisterEffect(e3)
end
function c29200117.cfilter(c,e,tp)
    return c:IsSetCard(0x53e0) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
        and (not e or c:IsRelateToEffect(e))
end
function c29200117.indcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c29200117.cfilter,1,nil,nil,tp)
end
function c29200117.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
end
function c29200117.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Filter(c29200117.cfilter,nil,e,tp)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c29200117.pcfilter(c)
    return c:IsSetCard(0x53e0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c29200117.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    local seq=e:GetHandler():GetSequence()
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
        and Duel.IsExistingMatchingCard(c29200117.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c29200117.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local seq=e:GetHandler():GetSequence()
    if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c29200117.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29200117.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29200117.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    local g=Group.FromCards(lsc,rsc):Filter(Card.IsDestructable,nil)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29200117.penop(e,tp,eg,ep,ev,re,r,rp)
    local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    local g=Group.FromCards(lsc,rsc)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29200117.discon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c29200117.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c29200117.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function c29200117.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x53e0)
end
function c29200117.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingMatchingCard(c29200117.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
        and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    local ct=Duel.GetMatchingGroupCount(c29200117.filter,tp,LOCATION_MZONE,0,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29200117.desop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end


