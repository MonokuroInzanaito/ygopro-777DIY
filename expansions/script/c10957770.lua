--KV-莜弥莉缇
function c10957770.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x239),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c10957770.efilter)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c10957770.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10957770.alpcon)
	e3:SetOperation(c10957770.alpop)
	c:RegisterEffect(e3)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetDescription(aux.Stringid(10957770,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c10957770.cost)
	e5:SetTarget(c10957770.target)
	e5:SetOperation(c10957770.operation)
	c:RegisterEffect(e5)
end
function c10957770.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10957770,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c10957770.alpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	return ep~=tp and c:GetFlagEffect(10957770)~=0 and not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c10957770.alpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	Duel.Hint(HINT_CARD,0,10957770)
	Duel.Recover(tp,500,REASON_EFFECT)
	Duel.SetLP(1-tp,lp-500)
end
function c10957770.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c10957770.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10957770.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_DESTORY,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c10957770.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetDecktopGroup(tp,1)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.Destroy(g1,REASON_EFFECT)
end
