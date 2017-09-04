--No.93 希望皇ホープ・カイザー
function c29200011.initial_effect(c)
    c:SetUniqueOnField(1,0,29200011)
    --xyz summon
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCondition(c29200011.xyzcon)
    e1:SetOperation(c29200011.xyzop)
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    --confirm
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29200011,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,29200011)
    e2:SetCost(c29200011.cost)
    e2:SetTarget(c29200011.target)
    e2:SetOperation(c29200011.operation)
    c:RegisterEffect(e2)
    --public
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_PUBLIC)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c29200011.condition)
    e3:SetTargetRange(0,LOCATION_HAND)
    c:RegisterEffect(e3)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c29200011.efilter)
    c:RegisterEffect(e4)
end
function c29200011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29200011.filter(c)
    return c:IsSetCard(0x33e0) and c:IsType(TYPE_XYZ)
end
function c29200011.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(c29200011.filter,1,nil)
end
function c29200011.efilter(e,re,rp)
    if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    return not g:IsContains(e:GetHandler())
end
function c29200011.mfilter(c,xyzc)
    return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:IsCanBeXyzMaterial(xyzc)
end
function c29200011.xyzfilter1(c,g,ct)
    return g:IsExists(c29200011.xyzfilter2,ct,c)
end
function c29200011.xyzfilter2(c)
    return c:GetRank()==5
end
function c29200011.xyzcon(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=nil
    if og then
        mg=og:Filter(c29200011.mfilter,nil,c)
    else
        mg=Duel.GetMatchingGroup(c29200011.mfilter,tp,LOCATION_MZONE,0,nil,c)
    end
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and mg:IsExists(c29200011.xyzfilter1,1,nil,mg)
end
function c29200011.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
    local g=nil
    local sg=Group.CreateGroup()
    if og then
        g=og
        local tc=og:GetFirst()
        while tc do
            sg:Merge(tc:GetOverlayGroup())
            tc=og:GetNext()
        end
    else
        local mg=Duel.GetMatchingGroup(c29200011.mfilter,tp,LOCATION_MZONE,0,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        g=mg:FilterSelect(tp,c29200011.xyzfilter1,1,1,nil,mg)
        local tc1=g:GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local g2=mg:FilterSelect(tp,c29200011.xyzfilter2,1,1,tc1)
        local tc2=g2:GetFirst()
        g:Merge(g2)
        sg:Merge(tc1:GetOverlayGroup())
        sg:Merge(tc2:GetOverlayGroup())
    end
    Duel.SendtoGrave(sg,REASON_RULE)
    c:SetMaterial(g)
    Duel.Overlay(c,g)
end
function c29200011.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 end
    Duel.Hint(HINT_SELECTMSG,tp,563)
    local rc=Duel.AnnounceRace(tp,1,0xffffff)
    e:SetLabel(rc)
    Duel.Hint(HINT_SELECTMSG,tp,562)
    local at=Duel.AnnounceAttribute(tp,1,0xffff)
    Duel.SetTargetParam(at)
end
function c29200011.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local tc=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1):GetFirst()
    Duel.ConfirmCards(tp,tc)
    local rc=e:GetLabel()
    local at=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    if tc:IsRace(rc) and tc:IsAttribute(at) then
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
        local ct=tc:GetLevel()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ct*200)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        e:GetHandler():RegisterEffect(e1)
    else 
	    Duel.ShuffleHand(1-tp)
    end
end
