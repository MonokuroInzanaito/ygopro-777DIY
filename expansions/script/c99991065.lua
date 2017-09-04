--传说之骑兵 莫德雷德
function c99991065.initial_effect(c)
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2e2),aux.FilterBoolFunction(c99991065.chfilter),true)
	c:EnableReviveLimit()
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c99991065.thtg)
	e1:SetOperation(c99991065.thop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c99991065.disop)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27346636,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c99991065.sprcon)
	e3:SetOperation(c99991065.sprop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(99991065,0))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,99991065)
    e4:SetTarget(c99991065.tg)
    e4:SetOperation(c99991065.op)
    c:RegisterEffect(e4)
end
function c99991065.chfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsFusionSetCard(0x62e0)
end
function c99991065.filter(c,seq)
	return c:GetSequence()==seq and c:IsAbleToDeck()
end
function c99991065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99991065.filter,tp,0,LOCATION_ONFIELD,1,nil,4-e:GetHandler():GetSequence()) end
	local g=Duel.GetMatchingGroup(c99991065.filter,tp,0,LOCATION_ONFIELD,nil,4-e:GetHandler():GetSequence())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99991065.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99991065.filter,tp,0,LOCATION_ONFIELD,nil,4-e:GetHandler():GetSequence())
	if  e:GetHandler():IsRelateToEffect(e) then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
end
function c99991065.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_SPELL) or rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end
function c99991065.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x2e2)  and c:IsAbleToGraveAsCost()  and c:IsCanBeFusionMaterial(fc)
	and Duel.IsExistingMatchingCard(c99991065.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c99991065.spfilter2(c)
	return  (c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsFusionSetCard(0x62e0)) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c99991065.spfilter3(c)
	return c:IsType(TYPE_EQUIP)   and c:IsAbleToGraveAsCost() 
end
function c99991065.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c99991065.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
		and Duel.IsExistingMatchingCard(c99991065.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c99991065.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c99991065.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c99991065.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local g3=Duel.SelectMatchingCard(tp,c99991065.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c99991065.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c99991065.op(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e)  and Duel.Remove(e:GetHandler(),nil,REASON_EFFECT)~=0 then
    Duel.BreakEffect()    
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0  and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
 end
end
end