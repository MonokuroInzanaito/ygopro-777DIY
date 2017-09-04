--天策·枪魂
function c60158910.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(nil),aux.NonTuner(Card.IsRace,RACE_WARRIOR))
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --must attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_MUST_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_MUST_BE_ATTACKED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.imval1)
    c:RegisterEffect(e3)
    --attack up
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(c60158910.condition)
    e2:SetOperation(c60158910.operation)
    c:RegisterEffect(e2)
    --replace
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60158910.condition2)
    e1:SetCost(c60158910.cost2)
    e1:SetTarget(c60158910.target2)
    e1:SetOperation(c60158910.operation2)
    c:RegisterEffect(e1)
    --Special Summon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c60158910.spcon2)
    e4:SetTarget(c60158910.sptg2)
    e4:SetOperation(c60158910.spop2)
    c:RegisterEffect(e4)
	
end
function c60158910.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle()
end
function c60158910.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(200)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
function c60158910.condition2(e,tp,eg,ep,ev,re,r,rp)
    if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()~=1 then return false end
    local tc=g:GetFirst()
    e:SetLabelObject(tc)
    return tc:IsOnField()
end
function c60158910.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60158910.zfilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
    return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c60158910.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tf=re:GetTarget()
    local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
    if chkc then return chkc:IsOnField() and c60158910.zfilter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
    if chk==0 then return Duel.IsExistingTarget(c60158910.zfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c60158910.zfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c60158910.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangeTargetCard(ev,Group.FromCards(tc))
    end
end
function c60158910.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c60158910.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60158910.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.BreakEffect()
		--direct attack
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60158910,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--immune
		local e2=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60158910,1))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c60158910.efilter)
		e2:SetCondition(c60158910.con)
        e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
    end
end
function c60158910.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c60158910.con(e)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
