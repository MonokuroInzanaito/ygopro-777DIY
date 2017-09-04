--刀庭-樱
function c80101023.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c80101023.activate)
    c:RegisterEffect(e1)
    --Atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c80101023.tg)
    e2:SetValue(200)
    c:RegisterEffect(e2)
    --extra summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
    e3:SetTarget(c80101023.tg)
    c:RegisterEffect(e3)
    --equip
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80101023,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetTarget(c80101023.eqtg)
    e4:SetOperation(c80101023.eqop)
    c:RegisterEffect(e4)
    local e8=e4:Clone()
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e8)
end
function c80101023.tg(e,c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_ZOMBIE)
end
function c80101023.filter(c)
    return c:IsSetCard(0x9400) and c:IsAbleToHand()
end
function c80101023.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c80101023.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(16178681,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c80101023.tgfilter(c,e,tp,chk)
    return c:IsSetCard(0x5400) and c:IsType(TYPE_MONSTER)
        and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
        and (chk or Duel.IsExistingMatchingCard(c80101023.cfilter,tp,LOCATION_GRAVE,0,1,nil,c))
end
function c80101023.cfilter(c,ec,tp)
    return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x6400) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c80101023.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and c80101023.tgfilter(chkc,e,tp,true) end
    local g=eg:Filter(c80101023.tgfilter,nil,e,tp,false)
    if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    if g:GetCount()==1 then
        Duel.SetTargetCard(g:GetFirst())
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local tc=g:Select(tp,1,1,nil)
        Duel.SetTargetCard(tc)
    end
end
function c80101023.eqop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local sg=Duel.SelectMatchingCard(tp,c80101023.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
        local ec=sg:GetFirst()
        if ec then
		    Duel.Equip(tp,ec,tc)
        end
    end
end


