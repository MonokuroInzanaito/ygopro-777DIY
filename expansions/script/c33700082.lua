--青龙的救济
function c33700082.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c33700082.cost)
	e2:SetTarget(c33700082.tg)
	e2:SetOperation(c33700082.op)
	c:RegisterEffect(e2)
	--deck check
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700082,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c33700082.spcon)
	e3:SetTarget(c33700082.sptg)
	e3:SetOperation(c33700082.spop)
	c:RegisterEffect(e3)
end
function c33700082.filter(c)
	return c:IsCode(33700174) and c:IsAbleToRemoveAsCost()
end
function c33700082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700082.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33700082.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c33700082.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c33700082.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SSet(tp,c)
	end
end
function c33700082.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
end
function c33700082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<hg then return false end
		return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c33700082.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700082.tfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c33700082.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.ConfirmDecktop(tp,hg)
	local g=Duel.GetDecktopGroup(tp,hg)
	if g:GetCount()>0 then
	 if g:GetClassCount(Card.GetCode)==g:GetCount() and g:IsExists(c33700082.spfilter,1,nil,e,tp) and not g:IsExists(c33700082.tfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
   else 
	  Duel.DisableShuffleCheck()
	  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
   end
end
end