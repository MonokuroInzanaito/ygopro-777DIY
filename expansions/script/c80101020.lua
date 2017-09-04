--刀术-风
function c80101020.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88204302,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,80101020+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c80101020.cost1)
    e1:SetTarget(c80101020.target1)
    e1:SetOperation(c80101020.activate1)
    c:RegisterEffect(e1)
    --negate activate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80101020,1))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCountLimit(1,80101020)
    e2:SetCondition(c80101020.condition)
    e2:SetCost(c80101020.cost)
    e2:SetTarget(c80101020.target)
    e2:SetOperation(c80101020.operation)
    c:RegisterEffect(e2)
end
function c80101020.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c80101020.filter(c,e,tp)
    return c:IsSetCard(0x5400) and c:GetAttack()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80101020.eqfilter(c,tc,tp)
    return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x6400) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp)
end
function c80101020.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80101020.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c80101020.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c80101020.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c80101020.activate1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
    if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
    local tg=Duel.GetMatchingGroup(c80101020.eqfilter,tp,LOCATION_GRAVE,0,nil,tc,tp)
        if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(55742055,4)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local sg=tg:Select(tp,1,1,nil)
            Duel.Equip(tp,sg:GetFirst(),tc,true)
        end
	end
end
function c80101020.sdfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5400) and c:IsType(TYPE_SYNCHRO)
end
function c80101020.condition(e,tp,eg,ep,ev,re,r,rp,chk)
    return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) 
		and Duel.IsExistingMatchingCard(c80101020.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80101020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80101020.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1000)
end
function c80101020.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c80101020.repop)
end
function c80101020.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,1000,REASON_EFFECT)
    Duel.Recover(1-tp,1000,REASON_EFFECT)
end
