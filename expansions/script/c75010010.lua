--战术人形作战中心
function c75010010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c75010010.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x520))
	e2:SetValue(c75010010.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75010010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,75010010)
	e3:SetCost(c75010010.drcost)
	e3:SetTarget(c75010010.drtg)
	e3:SetOperation(c75010010.drop)
	c:RegisterEffect(e3)
end
function c75010010.filter(c)
	return c:IsCode(75010011) and c:IsAbleToHand()
end
function c75010010.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c75010010.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75010010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c75010010.val(e,c)
	return c:GetCounter(0x520)*500
end
function c75010010.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c75010010.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c75010010.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c75010010.cfilter(c)
	return c:IsSetCard(0x520) and c:IsReleasable()
end
function c75010010.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75010010.filter2(c)
	return c:IsCanAddCounter(0x520,1) and c:IsSetCard(0x520)
end
function c75010010.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c75010010.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(75010010,2)) then
			Duel.BreakEffect()
			local tc=Duel.SelectMatchingCard(tp,c75010010.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if tc:GetCount()>0 then
				tc:GetFirst():AddCounter(0x520,1)
			end
		end
	end  
end