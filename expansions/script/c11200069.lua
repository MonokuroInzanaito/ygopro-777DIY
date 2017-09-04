--脱兔「Fluster Escape」
function c11200069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200069+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200069.target)
	e1:SetOperation(c11200069.activate)
	c:RegisterEffect(e1)	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c11200069.handcon)
	c:RegisterEffect(e2)
end
function c11200069.handcon(e)
	return not Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c11200069.spfilter(c,e,tp)
	return c:IsSetCard(0xffee) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11200069.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0)
end
function c11200069.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c11200069.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	if not b1 and not b2 then return end
	local op=0
	if b1 and b2 then
	   op=Duel.SelectOption(tp,aux.Stringid(11200069,0),aux.Stringid(11200069,1))
	elseif b1 then
	   op=Duel.SelectOption(tp,aux.Stringid(11200069,0))
	else
	   Duel.SelectOption(tp,aux.Stringid(11200069,1))
	   op=1
	end
	if op==0 then
	   c11200069.spfuntion(e,tp,eg,ep,ev,re,r,rp)
	   Duel.ShuffleDeck(tp)
	   c11200069.tdfuntion(e,tp,eg,ep,ev,re,r,rp)
	else
	   c11200069.tdfuntion(e,tp,eg,ep,ev,re,r,rp)
	   Duel.ShuffleDeck(tp)
	   c11200069.spfuntion(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c11200069.spfuntion(e,tp,eg,ep,ev,re,r,rp)
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c11200069.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	   end
end
function c11200069.tdfuntion(e,tp,eg,ep,ev,re,r,rp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	   if dg:GetCount()>0 then 
		  Duel.SendtoDeck(dg,nil,0,REASON_EFFECT)
	   end
end

