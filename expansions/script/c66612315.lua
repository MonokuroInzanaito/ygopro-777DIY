--赌博与戏法的物语
function c66612315.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,66612315)
	e0:SetTarget(c66612315.tg)
	e0:SetOperation(c66612315.activate)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x660))
	c:RegisterEffect(e1)
end
function c66612315.filter1(c)
	return c:IsSetCard(0x660) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c66612315.filter2(c)
	return c:IsSetCard(0x660) and c:IsType(TYPE_FUSION) and not c:IsSetCard(0xe660) and c:IsAbleToGrave()
end
function c66612315.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c66612315.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local t={}
	local p=1
	if Duel.SelectYesNo(tp,aux.Stringid(66612315,3)) then
	if Duel.IsExistingMatchingCard(c66612315.filter1,tp,LOCATION_DECK,0,2,nil)  then t[p]=aux.Stringid(66612315,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c66612315.filter2,tp,LOCATION_EXTRA,0,1,nil) then t[p]=aux.Stringid(66612315,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66612315,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(66612315,0)
	local sg=nil
	if opt==0 then sg=Duel.SelectMatchingCard(tp,c66612315.filter1,tp,LOCATION_DECK,0,2,2,nil)
	if sg:GetCount()>1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	else 
	sg=Duel.SelectMatchingCard(tp,c66612315.filter2,tp,LOCATION_EXTRA,0,1,1,nil) end
	if sg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
end