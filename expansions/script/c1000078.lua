--圣诞夜的虹纹
function c1000078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000078,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1000078)
	e2:SetCondition(c1000078.condition)
	e2:SetTarget(c1000078.target)
	e2:SetOperation(c1000078.operation)
	c:RegisterEffect(e2)
	--Revmod
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1000078,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1000078)
	e3:SetCost(c1000078.cost)
	e3:SetCondition(c1000078.condition1)
	e3:SetTarget(c1000078.target1)
	e3:SetOperation(c1000078.operation1)
	c:RegisterEffect(e3)
end
function c1000078.cfilter(c,tp)
	return c:IsSetCard(0x200) and c:IsControler(tp)
end
function c1000078.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000078.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c1000078.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000078.cfilter,1,nil,tp)
end
function c1000078.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(1000076) and not c:IsCode(999999788)
end
function c1000078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1000078.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1000078.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000078.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c1000078.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1000078.splimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x200)
end
function c1000078.desfilter(c)
	return c:IsSetCard(0x200) and c:IsAbleToDeckAsCost()
end
function c1000078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1000078.desfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
	local tg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1000078.filter(c)
	return c:IsAbleToRemove()
end
function c1000078.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c1000078.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1000078.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c1000078.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c1000078.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end