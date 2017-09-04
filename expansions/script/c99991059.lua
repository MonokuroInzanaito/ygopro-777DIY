--传说之裁定者 玛尔达
function c99991059.initial_effect(c)
    c:SetUniqueOnField(1,0,99991059)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),5,2,c99991059.ovfilter,aux.Stringid(99991059,0),2,c99991059.xyzop)
	c:EnableReviveLimit()
	--immune spell
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_IMMUNE_EFFECT)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetValue(c99991059.efilter)
    c:RegisterEffect(e0)
	--pierce
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(c99991059.picon)
    c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c99991059.aclimit)
	e2:SetCondition(c99991059.actcon)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99991059,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c99991059.atkcon)
	e3:SetCost(c99991059.atkcost)
	e3:SetTarget(c99991059.atktg)
	e3:SetOperation(c99991059.atkop)
	c:RegisterEffect(e3)
end
function c99991059.ovfilter(c)
	return c:IsFaceup() and c:IsCode(99991072) 
end
function c99991059.cfilter(c)
	return  c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c99991059.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991059.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99991059.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c99991059.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99991059.picon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget():IsRace(RACE_FAIRY+RACE_FIEND+RACE_ZOMBIE)
end
function c99991059.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99991059.actcon(e)
	return (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil) and ((Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget():IsRace(RACE_FAIRY+RACE_FIEND+RACE_ZOMBIE)) 
	or (Duel.GetAttackTarget()==e:GetHandler()  and Duel.GetAttacker():IsRace(RACE_FAIRY+RACE_FIEND+RACE_ZOMBIE)))
end
function c99991059.td(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function c99991059.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c99991059.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(99991059)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(99991059,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c99991059.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then  return Duel.IsExistingMatchingCard(c99991059.td,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) 	end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99991059.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c99991059.td,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(g:GetFirst():GetAttack())
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(g:GetFirst():GetDefense())
		c:RegisterEffect(e2)
	end
end
