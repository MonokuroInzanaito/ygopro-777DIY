--动物朋友 西之白虎
function c33700177.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	 --deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700177,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700177.target)
	e1:SetOperation(c33700177.operation)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33700177.spcon)
	e2:SetOperation(c33700177.spop)
	c:RegisterEffect(e2)
end
function c33700177.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<hg then return false end
		local g=Duel.GetDecktopGroup(tp,hg)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c33700177.operation(e,tp,eg,ep,ev,re,r,rp)
   local hg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,hg)
	local g=Duel.GetDecktopGroup(p,hg)
	if g:GetCount()>0 then
	 if g:GetClassCount(Card.GetCode)==g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
   else 
	  Duel.DisableShuffleCheck()
   end
end
end
function c33700177.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c33700177.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c33700177.confilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and mg:CheckWithSumEqual(Card.GetLevel,4,1,5,c)
end
function c33700177.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c33700177.confilter,tp,LOCATION_MZONE,0,nil)
	local g=mg:SelectWithSumEqual(tp,Card.GetLevel,4,1,5)
	Duel.SendtoGrave(g,REASON_COST)
end