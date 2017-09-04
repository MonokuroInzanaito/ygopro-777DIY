--传说之骑兵 玛尔达
function c99991072.initial_effect(c)
    c:SetUniqueOnField(1,0,99991072)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2,c99991072.ovfilter,aux.Stringid(99991072,0),2,c99991072.xyzop)
	c:EnableReviveLimit()
	--immune spell
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_IMMUNE_EFFECT)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetValue(c99991072.efilter)
    c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991072,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c99991072.cost)
	e1:SetTarget(c99991072.target)
	e1:SetOperation(c99991072.operation)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
	--recover
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99991072,2))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetOperation(c99991072.reop)
    c:RegisterEffect(e2)
end	
function c99991072.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c99991072.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c99991072.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991072.cfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c99991072.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99991072.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99991072.field(c,atk)
    return c:IsFaceup() and c:IsDestructable() and  (not atk or c:IsDefenseBelow(atk))
end
function c99991072.tg(c,def)
    return c:IsRace(RACE_DRAGON) and c:IsAttackAbove(def) and c:IsAbleToGraveAsCost()
end
function c99991072.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then local g=Duel.GetMatchingGroup(c99991072.field,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
		local mg,mdef=g:GetMinGroup(Card.GetDefense)
		e:SetLabel(0)
	return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) and 
    Duel.IsExistingMatchingCard(c99991072.tg,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,mdef) 	end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	local tg=Duel.SelectMatchingCard(tp,c99991072.tg,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,mdef)
	Duel.SendtoGrave(tg,REASON_COST)
	e:SetLabel(tg:GetFirst():GetAttack())
end
function c99991072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==0 end
	local dg=Duel.GetMatchingGroup(c99991072.field,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c99991072.operation(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c99991072.field,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Destroy(dg,REASON_EFFECT)
end
function c99991072.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,99991072)
    Duel.Recover(tp,500,REASON_EFFECT)
end
