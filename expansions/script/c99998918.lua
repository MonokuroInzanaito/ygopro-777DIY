--传说之魔术师 尼禄·克劳狄乌斯
function c99998918.initial_effect(c)
	  aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2e1),aux.FilterBoolFunction(c99998918.chfilter),true)
	c:EnableReviveLimit() 
   --Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99998918,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)   
	e1:SetCondition(c99998918.descon)  
	e1:SetCost(c99998918.descost)
	e1:SetTarget(c99998918.destg)
	e1:SetOperation(c99998918.desop)
	c:RegisterEffect(e1)
	local  e0=e1:Clone()
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,0x1e0)
	e0:SetCondition(c99998918.descon2)
	c:RegisterEffect(e0)
	 --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99998918.con)
	e2:SetTarget(c99998918.tg)
	e2:SetOperation(c99998918.op)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27346636,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c99998918.sprcon)
	e3:SetOperation(c99998918.sprop)
	c:RegisterEffect(e3)
end
function c99998918.chfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) or c:IsFusionSetCard(0xc2e0)
end
function c99998918.filter(c)
	return c:IsCode(99998910) and not c:IsDisabled() and c:IsFaceup()
end
function c99998918.descon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99998918.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99998918.descon2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c99998918.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99998918.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c99998918.desfilter(c,tp)
   local seq=c:GetSequence() 
   if c:IsLocation(LOCATION_MZONE) then
return not  Duel.GetFieldCard(tp,LOCATION_SZONE,seq) 
	elseif c:IsLocation(LOCATION_SZONE)  and seq<5 then
return not  Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
end
end
function c99998918.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and
  c99998918.desfilter(chkc,1-tp) and chkc:IscCntroler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c99998918.desfilter,tp,0,LOCATION_ONFIELD,1,nil,1-tp) end
   local tg=Duel.GetMatchingGroup(c99998918.desfilter,tp,0,LOCATION_ONFIELD,nil,1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99998918.desfilter,tp,0,LOCATION_ONFIELD,1,tg:GetCount(),nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local tc=g:GetFirst()
	while tc do
	Duel.SetChainLimit(c99998918.limit(tc))
	tc=g:GetNext()
	end
end
function c99998918.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c99998918.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c99998918.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c99998918.sfilter(c,tp)
	local code=c:GetCode()
	return code==99998910  and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c99998918.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99998918.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99998918.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99998918.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(99999932,0))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function c99998918.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x2e1)  and c:IsAbleToGraveAsCost()  and c:IsCanBeFusionMaterial(fc)
	and Duel.IsExistingMatchingCard(c99998918.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c99998918.spfilter2(c)
	return  (c:IsFusionAttribute(ATTRIBUTE_LIGHT) or c:IsFusionSetCard(0xc2e0)) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c99998918.spfilter3(c)
	return c:IsType(TYPE_EQUIP)   and c:IsAbleToGraveAsCost() 
end
function c99998918.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c99998918.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
		and Duel.IsExistingMatchingCard(c99998918.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c99998918.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c99998918.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c99998918.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local g3=Duel.SelectMatchingCard(tp,c99998918.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end