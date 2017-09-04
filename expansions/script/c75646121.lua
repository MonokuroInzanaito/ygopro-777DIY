--Stella-星末
function c75646121.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x10+CATEGORY_DRAW)
	e1:SetProperty(0x10)
	e1:SetType(0x40)
	e1:SetRange(0x4)
	e1:SetCountLimit(1)
	e1:SetCost(c75646121.cost)
	e1:SetTarget(c75646121.target)
	e1:SetOperation(c75646121.activate)
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e3:SetType(0x81)
	e3:SetCode(1014)
	e3:SetCountLimit(1,75646121)
	e3:SetProperty(0x14010)
	e3:SetTarget(c75646121.tgtg)
	e3:SetOperation(c75646121.tgop)
	c:RegisterEffect(e3)
end
function c75646121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end
function c75646121.filter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x62c3) and (c:IsLocation(0x10) or c:IsFaceup())
end
function c75646121.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c75646121.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c75646121.filter,tp,0x30,0,4,nil) end
	Duel.Hint(3,tp,507)
	local g=Duel.SelectTarget(tp,c75646121.filter,tp,0x30,0,4,4,nil)
	Duel.SetOperationInfo(0,0x10,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c75646121.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,0x40)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.SendtoDeck(tg,nil,0,0x40)
	Duel.Damage(1-tp,200,0x40)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,0x1) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,0x1+0x40)
	if ct==4 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,0x40)
	end
end
function c75646121.filter1(c,e,tp)
	return c:IsSetCard(0x62c3) and not c:IsCode(75646121) and (c:IsLocation(0x10) or c:IsFaceup()) and c:IsAbleToHand()
end
function c75646121.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and c75646121.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c75646121.filter1,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c75646121.filter1,tp,0x30,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c75646121.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,tp,0x40)~=0 then 
			Duel.Damage(1-tp,200,0x40)
		 end
	end
end