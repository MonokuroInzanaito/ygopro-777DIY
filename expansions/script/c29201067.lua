--镜世录 神之子
function c29201067.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --xyz summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29201067,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c29201067.xyzcon)
    e1:SetOperation(c29201067.xyzop)
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    --fuck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(29201067,3))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCost(c29201067.descost)
    e2:SetTarget(c29201067.destg1)
    e2:SetOperation(c29201067.desop1)
    c:RegisterEffect(e2)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(29201067,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCost(c29201067.descost)
    e3:SetTarget(c29201067.destg)
    e3:SetOperation(c29201067.desop)
    c:RegisterEffect(e3)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(29201067,5))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c29201067.pencon)
    e7:SetTarget(c29201067.pentg)
    e7:SetOperation(c29201067.penop)
    c:RegisterEffect(e7)
    --splimit
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetRange(LOCATION_PZONE)
    e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1,0)
    e12:SetCondition(c29201067.splimcon)
    e12:SetTarget(c29201067.splimit)
    c:RegisterEffect(e12)
    --half atk
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SET_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetValue(c29201067.atkval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetRange(LOCATION_PZONE)
    c:RegisterEffect(e5)
    --half def
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_SET_DEFENSE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetValue(c29201067.defval)
    c:RegisterEffect(e6)
    local e8=e6:Clone()
    e8:SetRange(LOCATION_PZONE)
    c:RegisterEffect(e8)
    --race
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e9:SetCode(EFFECT_CHANGE_LEVEL)
    e9:SetValue(5)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetRange(LOCATION_PZONE)
    c:RegisterEffect(e10)
    --race
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_FIELD)
    ea:SetRange(LOCATION_MZONE)
    ea:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    ea:SetCode(EFFECT_CHANGE_RANK)
    ea:SetValue(5)
    c:RegisterEffect(ea)
    local e11=ea:Clone()
    e11:SetRange(LOCATION_PZONE)
    c:RegisterEffect(e11)
end
c29201067.pendulum_level=5
function c29201067.atkval(e,c)
    return (c:GetBaseAttack()+c:GetBaseDefense())/2
end
function c29201067.defval(e,c)
    return (c:GetBaseDefense()+c:GetBaseAttack())/2
end
function c29201067.pencon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201067.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c29201067.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c29201067.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c29201067.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x63e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29201067.mfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) and c:IsDefenseBelow(1250)
end
function c29201067.xyzfilter1(c,g)
    return g:IsExists(c29201067.xyzfilter2,1,c) 
end
function c29201067.xyzfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsDefenseBelow(1250)
end
function c29201067.xyzcon(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c29201067.mfilter,tp,LOCATION_MZONE,0,nil)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and mg:IsExists(c29201067.xyzfilter1,1,nil,mg)
end
function c29201067.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
    local mg=Duel.GetMatchingGroup(c29201067.mfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g1=mg:FilterSelect(tp,c29201067.xyzfilter1,1,1,nil,mg)
    local tc1=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g2=mg:FilterSelect(tp,c29201067.xyzfilter2,1,1,tc1,tc1:GetLevel())
    local tc2=g2:GetFirst()
    g1:Merge(g2)
    local sg1=tc1:GetOverlayGroup()
    local sg2=tc2:GetOverlayGroup()
    sg1:Merge(sg2)
    Duel.SendtoGrave(sg1,REASON_RULE)
    c:SetMaterial(g1)
    Duel.Overlay(c,g1)
end
function c29201067.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29201067.filter1(c)
    return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function c29201067.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c29201067.filter1,tp,0,LOCATION_MZONE,1,nil)
           and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c29201067.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c29201067.filter1,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
        local tc=g:GetFirst()
        Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(tc)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        Duel.RaiseEvent(tc,EVENT_CUSTOM+29201000,e,0,tp,0,0)
    end
end
function c29201067.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29201067.desop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
