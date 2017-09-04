--幽暗的绿巨人鱼
function c20323003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20323003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,20323003)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c20323003.target)
	e1:SetOperation(c20323003.operation)
	c:RegisterEffect(e1)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20323003,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,20323003)
	e2:SetTarget(c20323003.lvtg)
	e2:SetOperation(c20323003.lvop)
	c:RegisterEffect(e2)
end
function c20323003.filter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsRace(RACE_FISH) and Duel.IsExistingMatchingCard(c20323003.filter2,tp,LOCATION_GRAVE,0,1,nil,lv,e,tp)
end
function c20323003.filter2(c,lv,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv and c:IsRace(RACE_FISH)
end
function c20323003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20323003.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c20323003.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20323003.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20323003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c20323003.filter2,tp,LOCATION_GRAVE,0,1,1,nil,lv,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c20323003.lvfilter(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsRace(RACE_FISH) and Duel.IsExistingMatchingCard(c20323003.lvfilter2,tp,LOCATION_DECK,0,1,nil,lv)
end
function c20323003.lvfilter2(c,lv)
	return c:IsAbleToGrave() and c:IsRace(RACE_FISH) and c:GetLevel()~=lv
end
function c20323003.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)   
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20323003.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20323003.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20323003.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20323003.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		local g=Duel.SelectMatchingCard(tp,c20323003.lvfilter2,tp,LOCATION_DECK,0,1,1,nil,lv)
		Duel.SendtoGrave(g,REASON_EFFECT)
		local lv2=g:GetFirst():GetLevel()
		if lv2==lv then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end