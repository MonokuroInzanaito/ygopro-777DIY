--6th-残肢乱置的失败品
function c66600610.initial_effect(c)
	--xyz summon
	  aux.AddXyzProcedure(c,c66600610.matfilter,3,2,nil,nil,5)
	c:EnableReviveLimit()
	--immue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66600610,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c66600610.con)
	e1:SetCost(c66600610.cost)
	e1:SetTarget(c66600610.tg)
	e1:SetOperation(c66600610.op)
	c:RegisterEffect(e1)
 --
	 local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetCondition(c66600610.flcon)
	e3:SetOperation(c66600610.flop)
	c:RegisterEffect(e3)
end
function c66600610.matfilter(c)
	return c:IsSetCard(0x66e)
end
function c66600610.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600610)>0 
end
function c66600610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600610.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c66600610.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(1)
			e3:SetValue(c66600610.efilter)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			c:RegisterEffect(e3)
	  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
   Duel.SendtoGrave(g,REASON_EFFECT)
		end
end
function c66600610.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c66600610.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600610.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600610,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end