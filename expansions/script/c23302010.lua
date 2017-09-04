--创符「流放人偶」
function c23302010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,23302010+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c23302010.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c23302010.aclimit)
	c:RegisterEffect(e2)
	--effect damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,23330181)
	e3:SetCost(c23302010.cost)
	e3:SetCondition(c23302010.discon)
	e3:SetOperation(c23302010.disop)
	c:RegisterEffect(e3)
end
function c23302010.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c23302010.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c23302010.damfilter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c23302010.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c23302010.damfilter,1,nil,1-tp) then
		Duel.Hint(HINT_CARD,0,23302010)
		Duel.Damage(1-tp,400,REASON_EFFECT)
	end
end
function c23302010.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c23302010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c23302010.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x992)
end
function c23302010.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c23302010.filter,tp,LOCATION_MZONE,0,1,nil) and (Duel.IsPlayerCanDiscardDeck(tp,2) or Duel.IsPlayerCanDiscardDeck(1-tp,2))
end
function c23302010.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,2) then
		if Duel.IsPlayerCanDiscardDeck(1-tp,2) and not Duel.SelectYesNo(tp,aux.Stringid(23302010,0)) then
			Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
		else
			Duel.DiscardDeck(tp,2,REASON_EFFECT)
		end
	elseif Duel.IsPlayerCanDiscardDeck(1-tp,2) then
		Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
	end
end