--6th-小白鼠们
function c66600603.initial_effect(c)
	--thm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600603,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCost(c66600603.cost) 
	e1:SetTarget(c66600603.tg)
	e1:SetOperation(c66600603.op)
	c:RegisterEffect(e1)   
	--ths
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66600603,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	 e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c66600603.thcon)
	e2:SetTarget(c66600603.thtg)
	e2:SetOperation(c66600603.thop)
	c:RegisterEffect(e2)
--
	 local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetCondition(c66600603.flcon)
	e3:SetOperation(c66600603.flop)
	c:RegisterEffect(e3)
end
function c66600603.cfilter(c)
	return c:IsSetCard(0x66e) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c66600603.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c66600603.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66600603.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SendtoGrave(g,REASON_COST)
end
function c66600603.thfilter(c,lv)
	return c:IsSetCard(0x66e) and c:IsAbleToHand() and lv and c:GetLevel()==lv
end
function c66600603.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600603.thfilter,tp,LOCATION_DECK,0,1,nil,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66600603.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66600603.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66600603.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600603)>0 
end

function c66600603.thfilter2(c)
	return c:IsSetCard(0x66e) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c66600603.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600603.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66600603.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66600603.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66600603.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600603.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600603,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end
