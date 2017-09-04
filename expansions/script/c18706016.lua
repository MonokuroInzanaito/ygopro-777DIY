--魔人少女 梅妮丝华兹
function c18706016.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xabb),2)
	c:EnableReviveLimit()
	--remove
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(52687916,0))
	--e1:SetCategory(CATEGORY_HANDES)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCondition(c18706016.remcon)
	--e1:SetCost(c18706016.cost)
	--e1:SetTarget(c18706016.remtg)
	--e1:SetOperation(c18706016.remop)
	--c:RegisterEffect(e1)
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e3:SetValue(c18706016.efilter)
	--c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c18706016.ind2)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35952884,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c18706016.discon)
	e3:SetCost(c18706016.discost)
	e3:SetTarget(c18706016.distg)
	e3:SetOperation(c18706016.disop)
	c:RegisterEffect(e3)
end
function c18706016.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c18706016.Rfilter(c,code)
	return c:GetCode()==code and c:IsAbleToRemove()
end
function c18706016.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c18706016.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingTarget(c18706016.mfilter,tp,0,LOCATION_MZONE,1,nil) then 
	if chk==0 then return Duel.IsExistingMatchingCard(c18706016.Rfilter,tp,LOCATION_GRAVE+LOCATION_DECK,LOCATION_GRAVE,1,nil,eg:GetFirst():GetCode()) end
	local g=Duel.SelectMatchingCard(tp,c18706016.Rfilter,tp,LOCATION_GRAVE+LOCATION_DECK,LOCATION_GRAVE,1,1,nil,eg:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
	if chk==0 then return Duel.IsExistingMatchingCard(c18706016.Rfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,eg:GetFirst():GetCode()) end
	local g=Duel.SelectMatchingCard(tp,c18706016.Rfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,eg:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c18706016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c18706016.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c18706016.ind2(e,c)
	return c:GetRace()==RACE_WARRIOR or c:GetRace()==RACE_SPELLCASTER or c:GetRace()==RACE_ZOMBIE or c:GetRace()==RACE_MACHINE
	or c:GetRace()==RACE_AQUA or c:GetRace()==RACE_PYRO or c:GetRace()==RACE_ROCK or c:GetRace()==RACE_WINDBEAST
	or c:GetRace()==RACE_PLANT or c:GetRace()==RACE_INSECT or c:GetRace()==RACE_THUNDER or c:GetRace()==RACE_DRAGON
	  or c:GetRace()==RACE_BEAST or c:GetRace()==RACE_BEASTWARRIOR or c:GetRace()==RACE_DINOSAUR or c:GetRace()==RACE_FISH
	  or c:GetRace()==RACE_SEASERPENT  or c:GetRace()==RACE_REPTILE  or c:GetRace()==RACE_PSYCHO  or c:GetRace()==RACE_DEVINE
	  or c:GetRace()==RACE_CREATORGOD  or c:GetRace()==RACE_WYRM
end
function c18706016.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (re:GetHandler():GetRace()==RACE_WARRIOR or re:GetHandler():GetRace()==RACE_SPELLCASTER or re:GetHandler():GetRace()==RACE_ZOMBIE or re:GetHandler():GetRace()==RACE_MACHINE
	or re:GetHandler():GetRace()==RACE_AQUA or re:GetHandler():GetRace()==RACE_PYRO or re:GetHandler():GetRace()==RACE_ROCK or re:GetHandler():GetRace()==RACE_WINDBEAST
	or re:GetHandler():GetRace()==RACE_PLANT or re:GetHandler():GetRace()==RACE_INSECT or re:GetHandler():GetRace()==RACE_THUNDER or re:GetHandler():GetRace()==RACE_DRAGON
	  or re:GetHandler():GetRace()==RACE_BEAST or re:GetHandler():GetRace()==RACE_BEASTWARRIOR or re:GetHandler():GetRace()==RACE_DINOSAUR or re:GetHandler():GetRace()==RACE_FISH
	  or re:GetHandler():GetRace()==RACE_SEASERPENT  or re:GetHandler():GetRace()==RACE_REPTILE  or re:GetHandler():GetRace()==RACE_PSYCHO  or re:GetHandler():GetRace()==RACE_DEVINE
	  or re:GetHandler():GetRace()==RACE_CREATORGOD  or re:GetHandler():GetRace()==RACE_WYRM)

end