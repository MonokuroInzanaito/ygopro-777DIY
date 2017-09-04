--没有你的完美世界
function c5012606.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c5012606.cost)
	e1:SetTarget(c5012606.target)
	e1:SetOperation(c5012606.activate)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5012606,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,5012606)
	e2:SetCost(c5012606.recost)
	e2:SetTarget(c5012606.tg)
	e2:SetOperation(c5012606.op)
	c:RegisterEffect(e2)
	 --add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x350)
	c:RegisterEffect(e3)
end
function c5012606.filter(c)
	return c:IsSetCard(0x350) and c:IsAbleToRemoveAsCost()
end
function c5012606.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012606.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,6,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5012606.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,6,6,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5012606.spfilter(c,e,tp)
	return c:IsSetCard(0x350) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	or (c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false))
	or  (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
	or (c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)))
end
function c5012606.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
	Duel.IsExistingMatchingCard(c5012606.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c5012606.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sp=Duel.GetMatchingGroup(c5012606.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local g=sp:RandomSelect(tp,1)
	local tc=g:GetFirst()
	if tc then 
	if tc:IsType(TYPE_SYNCHRO) then
	Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
	g:GetFirst():CompleteProcedure()
	elseif tc:IsType(TYPE_FUSION) then
	Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) 
	g:GetFirst():CompleteProcedure()
	elseif  tc:IsType(TYPE_XYZ)  and Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
	 g:GetFirst():CompleteProcedure()
	 if Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(5012606,0)) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,2,nil)
	local cg=tg:GetFirst()
	while cg do
	Duel.Overlay(tc,Group.FromCards(cg))
	cg=tg:GetNext()
	end
	end
	else 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	g:GetFirst():CompleteProcedure()
	end
	end
end
function c5012606.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5012606.defilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x350) and c:IsFaceup()
end
function c5012606.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012606.defilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c5012606.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x350) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c5012606.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c5012606.defilter,tp,LOCATION_GRAVE,0,nil)
	local tg=g:Select(tp,1,g:GetCount(),nil)
	if tg:GetCount()>0 and  Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 
	and  Duel.IsExistingMatchingCard(c5012606.thfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(5012606,1)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sp=Duel.SelectMatchingCard(tp,c5012606.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if sp:GetCount()>0 then
	Duel.SendtoHand(sp,nil,REASON_EFFECT)
	end
end
end