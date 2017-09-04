--镜世录 幽谷响
function c29201037.initial_effect(c)
    --return to Spell
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(29201037,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCountLimit(1,29201037)
    e4:SetCost(c29201037.cost)
    e4:SetTarget(c29201037.target)
    e4:SetOperation(c29201037.op)
    c:RegisterEffect(e4)
    --discard
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201037,1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,29201037)
    e2:SetTarget(c29201037.distg)
    e2:SetOperation(c29201037.disop)
    c:RegisterEffect(e2)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_ONFIELD)
    e12:SetTargetRange(1,0)
    e12:SetTarget(c29201037.splimit)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e13:SetRange(LOCATION_ONFIELD)
    e13:SetTargetRange(1,0)
    e13:SetTarget(c29201037.splimit)
    c:RegisterEffect(e13)
end
function c29201037.splimit(e,c)
    return not c:IsSetCard(0x63e0)
end
function c29201037.cffilter(c)
    return c:IsSetCard(0x63e0)  and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c29201037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201037.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c29201037.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function c29201037.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c29201037.filter(c)
    return c:IsDestructable()
end
function c29201037.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        local g=Duel.GetMatchingGroup(c29201037.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29201037,3)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local dg=g:Select(tp,1,1,e:GetHandler())
            Duel.HintSelection(dg)
            if Duel.Destroy(dg,REASON_EFFECT)~=0 then
                local tc=dg:GetFirst()
                if tc:IsSetCard(0x63e0) then
                    Duel.Draw(tp,1,REASON_EFFECT)
				end
            end
        end
    end
end
function c29201037.disfilter(c)
    return c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c29201037.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c29201037.disfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c29201037.disop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c29201037.disfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
	    Duel.SendtoGrave(g,REASON_EFFECT) 
        local g=Duel.GetMatchingGroup(c29201037.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29201037,3)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local dg=g:Select(tp,1,1,nil)
            Duel.HintSelection(dg)
            if Duel.Destroy(dg,REASON_EFFECT)~=0 then
                local tc=dg:GetFirst()
                if tc:IsSetCard(0x63e0) then
                    Duel.Draw(tp,1,REASON_EFFECT)
				end
            end
        end
	end
end
