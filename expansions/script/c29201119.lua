--天辉团-苍银骑士 海洛伊丝
function c29201119.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201119,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c29201119.sptg)
    e1:SetOperation(c29201119.spop)
    c:RegisterEffect(e1)
    --indes
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    ea:SetCode(EFFECT_DESTROY_REPLACE)
    ea:SetRange(LOCATION_PZONE)
    ea:SetTarget(c29201119.reptg)
    ea:SetValue(c29201119.repval)
    ea:SetOperation(c29201119.repop)
    c:RegisterEffect(ea)
    --control
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(29201119,0))
    e6:SetCategory(CATEGORY_CONTROL)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetTarget(c29201119.cttg)
    e6:SetOperation(c29201119.ctop)
    c:RegisterEffect(e6)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201119,4))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,29201119)
    e4:SetCondition(c29201119.thcon)
    e4:SetTarget(c29201119.thtg)
    e4:SetOperation(c29201119.thop)
    c:RegisterEffect(e4)
    local e8=e4:Clone()
    e8:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e8)
    local e9=e4:Clone()
    e9:SetCode(EVENT_TO_DECK)
    c:RegisterEffect(e9)
    --pierce
    local ed=Effect.CreateEffect(c)
    ed:SetType(EFFECT_TYPE_FIELD)
    ed:SetCode(EFFECT_PIERCE)
    ed:SetRange(LOCATION_PZONE)
    ed:SetTargetRange(LOCATION_MZONE,0)
    ed:SetTarget(c29201119.target4)
    c:RegisterEffect(ed)
end
function c29201119.target4(e,c)
    return c:IsSetCard(0x53e1) and c:IsType(TYPE_MONSTER) 
end
function c29201119.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x53e1) and c:IsDestructable()
end
function c29201119.desfilter2(c,e)
    return c29201119.desfilter(c) and c:IsCanBeEffectTarget(e)
end
function c29201119.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c29201119.desfilter(chkc) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    if chk==0 then return ct<=3 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c29201119.desfilter,tp,LOCATION_ONFIELD,0,3,nil)
        and (ct<=0 or Duel.IsExistingTarget(c29201119.desfilter,tp,LOCATION_MZONE,0,ct,nil)) end
    local g=nil
    if ct>0 then
        local tg=Duel.GetMatchingGroup(c29201119.desfilter2,tp,LOCATION_ONFIELD,0,nil,e)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        g=tg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
        if ct<3 then
            tg:Sub(g)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local g2=tg:Select(tp,3-ct,3-ct,nil)
            g:Merge(g2)
        end
        Duel.SetTargetCard(g)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        g=Duel.SelectTarget(tp,c29201119.desfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29201119.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
            Duel.SendtoGrave(c,REASON_RULE)
        end
    end
end
function c29201119.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x53e1)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c29201119.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c29201119.repfilter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectYesNo(tp,aux.Stringid(29201119,3))
end
function c29201119.repval(e,c)
    return c29201119.repfilter(c,e:GetHandlerPlayer())
end
function c29201119.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c29201119.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201119.thfilter(c)
    return (c:IsSetCard(0x33e1) or c:IsSetCard(0x53e1)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29201119.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c29201119.thfilter,tp,LOCATION_DECK,0,nil)
    if chk==0 then return g:CheckWithSumEqual(Card.GetLevel,9,1,3) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29201119.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c29201119.thfilter,tp,LOCATION_DECK,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:SelectWithSumEqual(tp,Card.GetLevel,9,1,3)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c29201119.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetBattleTarget()
    local c=e:GetHandler()
    if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsControlerCanBeChanged() 
       and c:GetLevel()>tc:GetLevel() end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c29201119.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() and not Duel.GetControl(tc,tp,PHASE_BATTLE,1) then
        if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
    --must attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MUST_ATTACK)
    e1:SetReset(RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c29201119.becon(e)
    return e:GetHandler():IsAttackable()
end


