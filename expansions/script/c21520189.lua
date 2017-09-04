--艺形魔-纸死神
function c21520189.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(c21520189.splimit)
	c:RegisterEffect(pe1)
	--SPECIAL_SUMMON
	local pe2=Effect.CreateEffect(c)
	pe2:SetDescription(aux.Stringid(21520189,4))
	pe2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	pe2:SetType(EFFECT_TYPE_IGNITION)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1)
	pe2:SetTarget(c21520189.sptg)
	pe2:SetOperation(c21520189.spop)
	c:RegisterEffect(pe2)
	--deck remove
	local pe3=Effect.CreateEffect(c)
	pe3:SetDescription(aux.Stringid(21520189,6))
	pe3:SetCategory(CATEGORY_REMOVE)
	pe3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	pe3:SetProperty(EFFECT_FLAG_DELAY)
	pe3:SetRange(LOCATION_PZONE)
	pe3:SetCode(EVENT_SPSUMMON_SUCCESS)
	pe3:SetCondition(c21520189.dkrcon)
--	pe3:SetTarget(c21520189.dkrtg)
	pe3:SetOperation(c21520189.dkrop)
	c:RegisterEffect(pe3)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetDescription(aux.Stringid(21520189,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21520189)
	e1:SetCost(c21520189.sdrcost)
	e1:SetTarget(c21520189.sdrtg)
	e1:SetOperation(c21520189.sdrop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520189,3))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520189)
	e2:SetOperation(c21520189.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520189,5))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,21520189)
	e4:SetCost(c21520189.sprcost)
	e4:SetTarget(c21520189.sprtg)
	e4:SetOperation(c21520189.sprop)
	c:RegisterEffect(e4)
end
function c21520189.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x490) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c21520189.spfilter(c,e,tp)
	return c:IsSetCard(0x490) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520189.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.IsExistingTarget(c21520189.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520189.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21520189.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local op=2
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(21520189,0),aux.Stringid(21520189,1))
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then
			op=0
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,0))
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			op=1
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,1))
		end
		if op==0 then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif op==1 then
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
		local atk=tc:GetAttack()
		Duel.Damage(tc:GetControler(),atk,REASON_EFFECT)
	end
end
function c21520189.dkrcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsSetCard,nil,0x490)>0
end
function c21520189.dkrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c21520189.dkrfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x490)
end
function c21520189.dkrop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)==0 then return end
	if eg:IsExists(c21520189.dkrfilter,1,nil) then 
		local g=Duel.GetDecktopGroup(1-tp,1)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c21520189.sdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST) 
end
function c21520189.sdrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsDistruable() end
	if chk==0 then return Duel.IsExistingTarget(c21520189.sdrfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520189.sdrfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler(),e,yp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21520189.sdrfilter(c,e,tp)
	return c:IsSetCard(0x490) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520189.sdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local p=tp
	if tc:IsRelateToEffect(e) then
		local op=2
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(21520189,0),aux.Stringid(21520189,1))
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then
			op=0
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,0))
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			op=1
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,1))
		end
		if op==1 then 
			p=1-tp
		end
		if Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP)>0 then
			local dg=Duel.GetMatchingGroup(Card.IsDestructable,p,LOCATION_MZONE,0,tc,e)
			local aval=0
			local dc=dg:GetFirst()
			while dc do
				aval=aval+dc:GetAttack()
				dc=dg:GetNext()
			end
			if Duel.Destroy(dg,REASON_EFFECT)>0 then 
				Duel.Recover(p,aval,REASON_EFFECT)
			end
		end
	end
end
function c21520189.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,6)
	Duel.ConfirmDecktop(tp,6)
	local tc=g:GetFirst()
	local tgg=Group.CreateGroup()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x490) then
			tgg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	local ct=Duel.SendtoGrave(tgg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local otg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SendtoGrave(otg,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
function c21520189.sprfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToRemoveAsCost()
end
function c21520189.sprcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520189.sprfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520189.sprfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520189.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,2,0,LOCATION_DECK)
end
function c21520189.sprop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) 
		or not Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,e:GetHandler()) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
