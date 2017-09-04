--传说之狂战士 茨木童子
function c99998924.initial_effect(c)
	 c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25415052,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99998924.descon)
	e2:SetTarget(c99998924.destg)
	e2:SetOperation(c99998924.desop)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(1)
	e4:SetCondition(c99998924.indcon)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	e5:SetCondition(c99998924.indcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e6)
  --cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
	--token
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(99998924,1))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e9:SetCost(c99998924.cost)
	e9:SetHintTiming(0,0x1e0)
	e9:SetTarget(c99998924.sptg)
	e9:SetOperation(c99998924.spop)
	c:RegisterEffect(e9)
	--disable
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e10:SetDescription(aux.Stringid(99998924,0))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetHintTiming(0,0x1e0)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e10:SetCost(c99998924.discost)
	e10:SetTarget(c99998924.distg)
	e10:SetOperation(c99998924.disop)
	c:RegisterEffect(e10)
  if c99998924.counter==nil then
		c99998924.counter=true
		c99998924[0]=0
		c99998924[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c99998924.resetcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_RELEASE)
		ge2:SetOperation(c99998924.addcount)
		Duel.RegisterEffect(ge2,0)
	end
end
function c99998924.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c99998924[0]=0
	c99998924[1]=0
end
function c99998924.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
			local p=tc:GetReasonPlayer()
			c99998924[p]=c99998924[p]+1
		tc=eg:GetNext()
	end
end
function c99998924.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c99998924.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
   local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,LOCATION_ONFIELD)
	 Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,g:GetCount(),0,0)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),0,0)
end
function c99998924.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,e:GetHandler())
	if g:GetCount()>0 then 
	Duel.Destroy(g,REASON_EFFECT)
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if c99998924[tp]<ft then
	ft=c99998924[tp]
end
   if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then
   ft=1
end
   if Duel.IsPlayerCanSpecialSummonMonster(tp,99998919,0,0x4011,800,800,1,RACE_FIEND,ATTRIBUTE_DARK) then
	 for i=1,ft do
				local op
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
				local token=Duel.CreateToken(tp,99998919)
				local s1=ft1>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false)
				local s2=ft2>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
				if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(99998924,2),aux.Stringid(99998924,3))
				elseif s1 then op=0
				elseif s2 then op=1
				else op=2 end
				if op==0 then Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				elseif op==1 then Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetValue(1)
				token:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				token:RegisterEffect(e4)
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
				e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				token:RegisterEffect(e5)
end
		   Duel.SpecialSummonComplete()
end
end
function c99998924.filter(c)
   return c:IsCode(99998919) and c:IsFaceup()
end
function c99998924.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99998924.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c99998924.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99998924.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		   or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99998919,0,0x4011,800,800,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99998924.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and
	Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0  then return end
	 local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,99998919,0,0x4011,0,0,800,800,1,RACE_FIEND,ATTRIBUTE_DARK) then
	  local token=Duel.CreateToken(tp,99998919)
	local s1=ft1>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=ft2>0 and token:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	 if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(99998924,2),aux.Stringid(99998924,3))
	elseif s1 then op=0
	elseif s2 then op=1
	else op=2 end
	if op==0 then Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	elseif op==1 then Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetValue(1)
				token:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				token:RegisterEffect(e4)
	  Duel.SpecialSummonComplete()
end
end
function c99998924.filter2(c)
   return c:IsCode(99998919) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c99998924.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998924.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   local g=Duel.SelectMatchingCard(tp,c99998924.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99998924.disfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c99998924.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99998924.disfilter(chkc) and  chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c99998924.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c99998924.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99998924.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)  and not tc:IsDisabled()  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
