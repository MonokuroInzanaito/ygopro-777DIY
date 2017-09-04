--Miracle Aya
function c10981041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10981041.ffilter,2,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)
	e1:SetOperation(c10981041.atkop)
	c:RegisterEffect(e1)  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10981041,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10981041)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10981041.sptg)
	e3:SetOperation(c10981041.spop)
	c:RegisterEffect(e3)   
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10981041,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,10981041)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c10981041.target)
	e4:SetOperation(c10981041.operation)
	c:RegisterEffect(e4) 
end
function c10981041.ffilter(c)
	return c:IsFacedown()
end
function c10981041.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c10981041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c10981041.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10981041.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,2)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,2):Filter(c10981041.filter,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10981041,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)
	end
	Duel.ShuffleDeck(tp)
end
function c10981041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
end
function c10981041.filter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TRAP)
end
function c10981041.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,2) then return end
	Duel.ConfirmDecktop(tp,2)
	local g=Duel.GetDecktopGroup(tp,2)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c10981041.filter2,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10981041,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c10981041.filter2,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
