--扑克魔术 悠然的甜美
function c66612307.initial_effect(c)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x660),c66612307.ffilter,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c66612307.sprcon)
	e1:SetOperation(c66612307.sprop)
	c:RegisterEffect(e1)
	--POS
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66612307,2))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c66612307.target)
	e2:SetOperation(c66612307.activate)
	c:RegisterEffect(e2)
	--limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c66612307.splimit)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c66612307.tdcon)
	e4:SetCost(c66612307.tdcost)
	e4:SetTarget(c66612307.tdtg)
	e4:SetOperation(c66612307.tdop)
	c:RegisterEffect(e4)
	--sp
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66612308,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,66612307+EFFECT_COUNT_CODE_DUEL)
	e5:SetCost(c66612307.pucost)
	e5:SetTarget(c66612307.putg)
	e5:SetOperation(c66612307.puop)
	c:RegisterEffect(e5)
end
function c66612307.ffilter(c)
	return c:GetLevel()==1 or c:GetLevel()==5
end
function c66612307.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xe660)
end
function c66612307.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x660)  and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c66612307.spfilter2,tp,LOCATION_MZONE,0,1,c,fc)
end
function c66612307.spfilter2(c,fc)
	return (c:GetLevel()==1 or c:GetLevel()==5)  and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c66612307.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c66612307.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c66612307.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66612307,0))
	local g1=Duel.SelectMatchingCard(tp,c66612307.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66612307,1))
	local g2=Duel.SelectMatchingCard(tp,c66612307.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c66612307.filter(c)
	return  c:IsFaceup()  and c:IsCanTurnSet() 
end
function c66612307.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and c66612307.filter(chkc) and  chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c66612307.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c66612307.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c66612307.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end
end
function c66612307.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) 
end
function c66612307.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c66612307.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)   end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66612307.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
end
function c66612307.pucost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c66612307.puspfilter(c,e,tp)
	return c:IsSetCard(0x660) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c66612307.putg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66612307.puspfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp)
	and Duel.GetFlagEffect(tp,66612301)==0  and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	and not Duel.IsPlayerAffectedByEffect(tp,59822133)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c66612307.puop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,66612361)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or  Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66612307.puspfilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	if g:GetCount()>1 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end