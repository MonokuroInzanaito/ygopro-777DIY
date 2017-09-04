--刀魂-数珠丸
function c80101016.initial_effect(c)
    c:SetUniqueOnField(1,0,80101016)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsSetCard,0x5400),1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(80101016,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c80101016.thcon)
    e1:SetTarget(c80101016.eqtg)
    e1:SetOperation(c80101016.eqop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101016,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c80101016.thcon1)
    e2:SetCost(c80101016.spcost)
    e2:SetTarget(c80101016.sptg)
    e2:SetOperation(c80101016.spop)
    c:RegisterEffect(e2)
    --atk
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80101016,2))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c80101016.thcon2)
    e4:SetTarget(c80101016.target)
    e4:SetOperation(c80101016.operation)
    c:RegisterEffect(e4)
end
function c80101016.thcon(e)
    return e:GetHandler():GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x6400)<=1
end
function c80101016.thcon1(e)
    return e:GetHandler():GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x6400)>=2
end
function c80101016.thcon2(e)
    return e:GetHandler():GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x6400)>=3
end
function c80101016.filter(c,e,tp,ec)
    return c:IsSetCard(0x6400)  and c:IsType(TYPE_EQUIP) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c80101016.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80101016.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetMatchingGroup(c80101016.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g1=g:Select(tp,1,1,nil)
    g:RemoveCard(g1:GetFirst())
    if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80101013,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
    end
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c80101016.eqop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if ft<g:GetCount() then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,true,true)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
end
c80101016.list={
[80101006]=80101001,
[80101007]=80101002,
[80101008]=80101003,
[80101009]=80101004,
[80101010]=80101005,
[80101018]=80101017
}
function c80101016.rfilter(c,e,tp)
    local code=c:GetCode()
    local tcode=c80101016.list[code]
    return tcode and c:IsAbleToGrave()
        and Duel.IsExistingMatchingCard(c80101016.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tcode,e,tp)
end
function c80101016.spfilter(c,tcode,e,tp)
    return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    return true
end
function c80101016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=1 then return false end
        e:SetLabel(0)
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(c80101016.rfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c80101016.rfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    e:SetLabel(tc:GetCode())
    Duel.SendtoGrave(g,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c80101016.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local code=e:GetLabel()
    local tcode=c80101016.list[code]
    local sg=Duel.SelectMatchingCard(tp,c80101016.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tcode,e,tp)
    if sg:GetCount()>0 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c80101016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c80101016.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local ct=e:GetHandler():GetEquipCount()
        local preatk=tc:GetAttack()
        local predef=tc:GetDefense()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(ct*-500)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        if (preatk~=0 and tc:GetAttack()<=2000) or (predef~=0 and tc:GetDefense()<=2000) then
			Duel.Remove(tc,POS_FACEUP,REASON_RULE)
	    end
    end
end


