--阿尔贝特·修曼
function c75646313.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x200)
	e1:SetType(0x82)
	e1:SetRange(0x2)
	e1:SetProperty(0x14000)
	e1:SetCode(1011)
	e1:SetCondition(c75646313.spcon)
	e1:SetTarget(c75646313.sptg)
	e1:SetOperation(c75646313.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x10010)
	e2:SetType(0x40)
	e2:SetProperty(0x10)
	e2:SetRange(0x4)
	e2:SetCountLimit(1)
	e2:SetTarget(c75646313.target)
	e2:SetOperation(c75646313.operation)
	c:RegisterEffect(e2)
end
function c75646313.spfilter(c,tp)
	return c:IsPreviousPosition(0x5) and c:IsPreviousLocation(0xc)
		and c:GetPreviousControler()==tp and c:IsSetCard(0x52c3)
end
function c75646313.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646313.spfilter,1,nil,tp)
end
function c75646313.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,0x04)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,0x200,e:GetHandler(),1,0,0)
end
function c75646313.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,0x5)==0 and Duel.GetLocationCount(tp,0x04)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(0x02) then
		Duel.SendtoGrave(c,0x400)
	end
end
function c75646313.filter(c)
	return (c:IsSetCard(0x32c3) or c:IsSetCard(0x52c3)) and c:IsAbleToDeck() and (c:IsLocation(0x10) or c:IsFaceup())
end
function c75646313.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c75646313.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c75646313.filter,tp,0x30,0,5,nil) end
	Duel.Hint(3,tp,507)
	local g=Duel.SelectTarget(tp,c75646313.filter,tp,0x30,0,5,5,nil)
	Duel.SetOperationInfo(0,0x10,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,0x10000,nil,0,tp,2)
end
function c75646313.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,0x40)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,0x40)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,0x01) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,0x41)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,0x40)
	end
end