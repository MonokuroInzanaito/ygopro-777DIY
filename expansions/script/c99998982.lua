--传说之狂战士 李书文
function c99998982.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,nil,5,2,c99998982.ovfilter,aux.Stringid(99991098,12))
	c:EnableReviveLimit()
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetCondition(c99998982.becon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c99998982.becon)
	c:RegisterEffect(e2)	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20366274,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetCost(c99998982.cost)
	e3:SetTarget(c99998982.destg)
	e3:SetOperation(c99998982.desop)
	c:RegisterEffect(e3)
end
function c99998982.ovfilter(c)
	return c:IsFaceup()  and c:IsCode(99999931) and c:GetOverlayCount()==0
end
function c99998982.becon(e)
return e:GetHandler():IsAttackable() and e:GetHandler():GetOverlayCount()==0
end
function c99998982.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99998982.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c99998982.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 and g:GetFirst():IsType(TYPE_MONSTER) then
	local atk=g:GetFirst():GetBaseAttack()
	if atk>0 then
	Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
end