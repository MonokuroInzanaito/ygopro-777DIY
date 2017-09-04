--镜世录 月时计
function c29201050.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),aux.NonTuner(Card.IsSetCard,0x63e0),1)
    c:EnableReviveLimit()
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201050,3))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201050.pencon)
    e7:SetTarget(c29201050.pentg)
    e7:SetOperation(c29201050.penop)
    c:RegisterEffect(e7)
    --return to monster
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201050,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(c29201050.con2)
    e4:SetTarget(c29201050.sptg)
    e4:SetOperation(c29201050.op)
    c:RegisterEffect(e4)
    --return hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201050,4))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c29201050.thcon)
    e1:SetTarget(c29201050.thtg)
    e1:SetOperation(c29201050.thop)
    c:RegisterEffect(e1)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetValue(c29201050.immval)
    c:RegisterEffect(e3)
end
function c29201050.immval(e,te)
    return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
        and te:GetOwner():GetBaseAttack()<=3000 and te:GetOwner():GetBaseAttack()>=0
end
function c29201050.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c29201050.desfilter(c)
    return c:IsSetCard(0x63e0) and c:IsDestructable()
end
function c29201050.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201050.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c29201050.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201050.desfilter,tp,LOCATION_ONFIELD,0,1,99,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29201050.thop(e,tp,eg,ep,ev,re,r,rp)
        local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
        local ct=Duel.Destroy(g,REASON_EFFECT)
		--local tc=g:GetFirst()
        local op=0
        local b1=Duel.IsPlayerCanDraw(tp,ct)
        local b2=Duel.GetLP(tp)>0
        if b1 and b2 then 
        	op=Duel.SelectOption(tp,aux.Stringid(29201050,0),aux.Stringid(29201050,1))
        elseif b1 then 
        	op=Duel.SelectOption(tp,aux.Stringid(29201050,0))
        elseif b2 then 
        	Duel.SelectOption(tp,aux.Stringid(29201050,1)) op=1
        else 
        	return 
    	end
        if op==0 then
            Duel.Draw(tp,ct,REASON_EFFECT)
        else
            Duel.Recover(tp,ct*1000,REASON_EFFECT)
        end
end
function c29201050.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201050.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201050.penop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        Duel.RaiseEvent(c,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
end

function c29201050.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c29201050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201050.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if c:IsRelateToEffect(e) then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
            Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
            return
        end
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
