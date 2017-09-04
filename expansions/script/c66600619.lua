--6th-失乐园之下
function c66600619.initial_effect(c)
	--Activate
	--td
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c66600619.activate)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c66600619.con)
    e1:SetCost(c66600619.cost)
	e1:SetOperation(c66600619.op)
	c:RegisterEffect(e1)
end
function c66600619.filter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x66e)
and c:IsType(TYPE_MONSTER)
end
function c66600619.filter1(c,tp)
	return c:IsFaceup() and  c:IsSetCard(0x66e) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c66600619.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c66600619.filter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(66600619,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c66600619.con(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g  then return false end
    return g:IsExists(c66600619.filter1,1,nil,tp)
end
function c66600619.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600619.refilter,tp,LOCATION_GRAVE,0,1,nil) end
	  local g=Duel.SelectMatchingCard(tp,c66600619.refilter,tp,LOCATION_GRAVE,0,1,1,nil)
	   Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66600619.refilter(c)
	return  c:IsAbleToRemoveAsCost() and  c:IsSetCard(0x66e)
end
function c66600619.op(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end 
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
     local tg=g:Filter(c66600619.filter1,nil,tp)
	  local dg=tg:GetFirst()
	  while dg do
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetRange(LOCATION_MZONE)
            e3:SetCode(EFFECT_IMMUNE_EFFECT)
            e3:SetValue(1)
            e3:SetValue(c66600619.efilter)
            e3:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
            dg:RegisterEffect(e3)
			dg=tg:GetNext()
        end
end
function c66600619.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end