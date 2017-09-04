--圣都 罗尔萨克斯
function c29201100.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(c29201100.destg)
    e4:SetOperation(c29201100.desop)
    c:RegisterEffect(e4)
    --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c29201100.aclimit)
    e3:SetCondition(c29201100.actcon)
    c:RegisterEffect(e3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c29201100.tg)
    e2:SetValue(400)
    c:RegisterEffect(e2)
    local e9=e2:Clone()
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    c:RegisterEffect(e9)
end
function c29201100.tg(e,c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1))
end
function c29201100.actfilter(c,tp)
    return c and c:IsFaceup() and (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c29201100.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c29201100.actcon(e)
    local tp=e:GetHandlerPlayer()
    return c29201100.actfilter(Duel.GetAttacker(),tp) or c29201100.actfilter(Duel.GetAttackTarget(),tp)
end
function c29201100.desfilter(c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c29201100.filter(c,e,tp)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201100.desfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c29201100.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c29201100.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c29201100.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29201100.desop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
    local g=Duel.SelectMatchingCard(tp,c29201100.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        local tc1=g1:GetFirst()
        if tc1 then
            Duel.BreakEffect()
            Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
        end
    end
    end
end

