--6th-梦魇的猫咪
function c66600601.initial_effect(c)
	--spsummon
	 local e1=Effect.CreateEffect(c)
	 e1:SetDescription(aux.Stringid(66600601,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
   e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
   e1:SetCode(EVENT_CHAINING)
   e1:SetCondition(c66600601.spcon)
	e1:SetTarget(c66600601.sptg)
	e1:SetOperation(c66600601.spop)
	c:RegisterEffect(e1)
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66600601,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c66600601.cost)
	e2:SetCondition(c66600601.con)
	e2:SetTarget(c66600601.tg)
	e2:SetOperation(c66600601.op)
	c:RegisterEffect(e2)
	--
	 local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetCondition(c66600601.flcon)
	e3:SetOperation(c66600601.flop)
	c:RegisterEffect(e3)
   local e4=e3:Clone()
   	e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c66600601.hflcon)
	e4:SetOperation(c66600601.hflop)
	c:RegisterEffect(e4)
end
function c66600601.spcon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetFlagEffect(66600601)>0 
 end
function c66600601.filter(c,e,tp)
	return c:GetCode()~=66600601 and c:GetLevel()==3
   and c:IsSetCard(0x66e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66600601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66600601.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66600601.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66600601.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function c66600601.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x66e) and c:IsFaceup()
end
function c66600601.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(66600601)==0 end
	c:RegisterFlagEffect(66600601,RESET_CHAIN,0,1)
end
function c66600601.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600602)>0 
end
function c66600601.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66600601.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c66600601.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600601.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600601,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end
function c66600601.hflcon(e,tp,eg,ep,ev,re,r,rp)
  	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g  then return false end
	return g:IsExists(c66600601.tgfilter,1,nil,tp)
end
function c66600601.hflop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600602,RESET_CHAIN,0,1) 
end