--命运扑克魔术 幻想坎特雷拉
function c66612314.initial_effect(c)
	aux.AddFusionProcFun2(c,c66612314.filter1,c66612314.filter2,true)
	c:SetUniqueOnField(1,0,66612314)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66612314,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c66612314.tg)
	e1:SetOperation(c66612314.op)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c66612314.splimit)
	c:RegisterEffect(e2)
	--burn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c66612314.handes)
	c:RegisterEffect(e3)
	--fusion limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--all remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66612314,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c66612314.recost)
	e5:SetTarget(c66612314.retg)
	e5:SetOperation(c66612314.reop)
	c:RegisterEffect(e5)
end
function c66612314.filter1(c)
	return c:IsFusionSetCard(0x660) and c:IsFusionType(TYPE_FUSION)
end
function c66612314.filter2(c)
	return c:IsFusionCode(66612312)
end
function c66612314.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c66612314.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612314.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	 local g=Duel.GetMatchingGroup(c66612314.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c66612314.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66612314.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
end
function c66612314.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66612314.handes(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp  or id==c66612314[0]	then return end
	c66612314[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(66612314,2)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	else 
		if Duel.Damage(1-tp,1500,REASON_EFFECT)>0 then
		  local c1=Duel.TossCoin(tp,1)
		  if c1==1 then
		  Duel.NegateActivation(ev)
end
end
end
end
function c66612314.cfilter(c)
	return c:IsFaceup() and c:IsCode(66612313) and c:IsAbleToRemoveAsCost()
end
function c66612314.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c66612314.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66612314.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66612314.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(c66612314.climit)
end
function c66612314.climit(e,rp,tp)
		return tp==rp
end
function c66612314.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,66612361)
	Duel.Hint(HINT_CARD,0,66612362)
	Duel.Hint(HINT_CARD,0,66612363)
	Duel.Hint(HINT_CARD,0,66612364)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end
