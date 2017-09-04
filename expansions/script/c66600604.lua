--6th-未熟的实验体
function c66600604.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c66600604.spcon)
	e1:SetOperation(c66600604.spop)
	c:RegisterEffect(e1)
	--td
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66600604,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetRange(LOCATION_MZONE)
   e2:SetType(EFFECT_TYPE_QUICK_O)
   e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c66600604.tdcon)
	e2:SetTarget(c66600604.tdtg)
	e2:SetOperation(c66600604.tdop)
	c:RegisterEffect(e2)
 --
	 local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e3:SetCode(EVENT_CHAINING)
   e3:SetCondition(c66600604.flcon)
	e3:SetOperation(c66600604.flop)
	c:RegisterEffect(e3)
end
function c66600604.spfilter(c)
	return c:IsSetCard(0x66e) and c:IsType(TYPE_MONSTER) and  c:IsAbleToRemoveAsCost()
end
function c66600604.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66600604.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function c66600604.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66600604.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66600604.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600604)>0 
end
function c66600604.tdfilter(c)
	return c:IsSetCard(0x66e) and c:IsAbleToDeck() and c:IsType(TYPE_SPELL)
end
function c66600604.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600604.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
   Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66600604.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c66600604.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
	 Duel.ShuffleDeck(tp)
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c66600604.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600604.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600604,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end