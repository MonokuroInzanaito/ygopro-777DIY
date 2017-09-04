--扑克魔术 随想曲
function c66612309.initial_effect(c)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x660),c66612309.ffilter,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c66612309.sprcon)
	e1:SetOperation(c66612309.sprop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66612309,3))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c66612309.condition)
	e2:SetCost(c66612309.cost)
	e2:SetTarget(c66612309.negtg)
	e2:SetOperation(c66612309.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66612309,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c66612309.condition)
	e3:SetCost(c66612309.cost)
	e3:SetTarget(c66612309.retg)
	e3:SetOperation(c66612309.reop)
	c:RegisterEffect(e3)
	--limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(c66612309.splimit)
	c:RegisterEffect(e4)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c66612309.tdcon)
	e5:SetCost(c66612309.tdcost)
	e5:SetTarget(c66612309.tdtg)
	e5:SetOperation(c66612309.tdop)
	c:RegisterEffect(e5)
	--sp
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66612308,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,66612309+EFFECT_COUNT_CODE_DUEL)
	e6:SetCost(c66612309.pucost)
	e6:SetTarget(c66612309.putg)
	e6:SetOperation(c66612309.puop)
	c:RegisterEffect(e6)
end
function c66612309.ffilter(c)
	return c:GetLevel()==3 or c:GetLevel()==7
end
function c66612309.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xe660)
end
function c66612309.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x660)  and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c66612309.spfilter2,tp,LOCATION_MZONE,0,1,c,fc)
end
function c66612309.spfilter2(c,fc)
	return (c:GetLevel()==3 or c:GetLevel()==7)  and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c66612309.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c66612309.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c66612309.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66612309,0))
	local g1=Duel.SelectMatchingCard(tp,c66612309.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66612309,1))
	local g2=Duel.SelectMatchingCard(tp,c66612309.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c66612309.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g  then return false end
	return g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
end
function c66612309.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c66612309.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c66612309.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c66612309.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c66612309.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	local tg=g:Filter(Card.IsAbleToRemove,nil)
	if tg:GetCount()>0 then
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
end
function c66612309.val(e,c)
	return  c:IsSetCard(0x660) and c~=e:GetHandler()
end
function c66612309.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) 
end
function c66612309.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c66612309.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)   end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66612309.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
end
function c66612309.pucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0
		and not Duel.IsExistingMatchingCard(Card.IsPublic,tp,LOCATION_HAND,0,1,nil)  end
	local tg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local tc=tg:GetFirst()
    while tc do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
    tc=tg:GetNext()
	end
end
function c66612309.puthfilter(c)
	return c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c66612309.pufufilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c66612309.putg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612309.puthfilter,tp,LOCATION_REMOVED,0,1,nil)
	and Duel.GetFlagEffect(tp,66612301)==0  and Duel.IsExistingMatchingCard(c66612309.pufufilter,tp,LOCATION_MZONE,0,1,nil)	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,0)
end
function c66612309.puop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,66612363)
    local g=Duel.GetMatchingGroupCount(c66612309.pufufilter,tp,LOCATION_MZONE,0,nil)
	if g>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local rg=Duel.SelectMatchingCard(tp,c66612309.puthfilter,tp,LOCATION_REMOVED,0,1,g,nil)
    if rg:GetCount()>0 then
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,rg)
	end
end
end