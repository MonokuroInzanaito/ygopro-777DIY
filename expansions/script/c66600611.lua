--6th-改造体之骸天使
function c66600611.initial_effect(c)
   --xyz summon
	 aux.AddXyzProcedure(c,c66600611.matfilter,7,2)  
	c:EnableReviveLimit()
	--immue
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c66600611.con)
	e1:SetTarget(c66600611.tg)
	e1:SetOperation(c66600611.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66600611,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c66600611.cost)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return c66600611.tgfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler() end
	if chk==0 then return eg:IsExists(c66600611.spfilter,1,e:GetHandler(),tp) and Duel.IsExistingTarget(c66600611.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
		local g=eg:Filter(c66600611.spfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectTarget(tp,c66600611.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	   Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
 Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	end)
	e2:SetOperation(c66600611.ntrop)
	c:RegisterEffect(e2)
end
function c66600611.matfilter(c)
	return c:IsSetCard(0x66e)
end
function c66600611.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c66600611.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e)
end
function c66600611.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66600611.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66600611.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66600611.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66600611.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(66600611,1))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(c66600611.efilter)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
	end
end
function c66600611.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c66600611.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e) and c:IsAbleToGrave() and c:GetBaseAttack()>0
end
function c66600611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c66600611.spfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and not c:IsDisabled() and c:IsControlerCanBeChanged()
end
function c66600611.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=eg:Filter(c66600611.spfilter,nil,tp)
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c66600611.tgfilter,nil)
 if Duel.GetLocationCount(tp,LOCATION_MZONE)<g1:GetCount() then return end	
if g2:GetCount()>0 and g1:GetCount()>0 then
		local val=g2:GetFirst():GetBaseAttack()
		local tc=g1:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e4:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e4)
			end
			Duel.GetControl(tc,tp)
			tc=g1:GetNext() 
		end
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end