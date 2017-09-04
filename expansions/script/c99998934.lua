--传说之弓兵 伊修塔尔
function c99998934.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c99998934.spcon)
	e1:SetOperation(c99998934.spop)
	c:RegisterEffect(e1)
	--destroy
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998934,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e2:SetCost(c99998934.cost)
	e2:SetTarget(c99998934.tg)
	e2:SetOperation(c99998934.op)
	c:RegisterEffect(e2)
--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(200)
	c:RegisterEffect(e3)
end
function c99998934.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP+TYPE_CONTINUOUS)
end
function c99998934.spfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP+TYPE_CONTINUOUS)
 and c:IsAbleToRemoveAsCost()
end
function c99998934.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99998934.spfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.IsExistingMatchingCard(c99998934.spfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c99998934.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c99998934.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c99998934.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c99998934.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998934.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and  e:GetHandler():GetAttackAnnouncedCount()==0 end
	local g=Duel.SelectMatchingCard(tp,c99998934.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c99998934.filter(c)
	return c:IsFaceup() 
end
function c99998934.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c99998934.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c99998934.filter,tp,0,LOCATION_MZONE,nil)
	local a=0
	  local tc=g:GetFirst()
		while tc do
			local td=tc:GetDefense()
			if td<c:GetAttack() then
			a=a+(c:GetAttack()-td)
			tc=g:GetNext()
		end
		end
Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,a)
end
function c99998934.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c99998934.filter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
	   if not c:IsRelateToEffect(e) or c:IsFacedown() then return end  
	  Duel.BreakEffect()
		 local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local a=0
		while tc do
			local td=tc:GetDefense()
			if td<c:GetAttack() then
			a=a+(c:GetAttack()-td)
			tc=dg:GetNext()
		end
		end
if a>0 then
			Duel.Damage(1-tp,a,REASON_EFFECT)
		end
	end
end

