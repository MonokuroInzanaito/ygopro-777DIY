--Stella-星夜
function c75646116.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75646116)
	e1:SetCost(c75646116.drcost)
	e1:SetTarget(c75646116.drtg)
	e1:SetOperation(c75646116.drop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646116,1))
	e2:SetCategory(0x200+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,75646116)
	e2:SetCost(c75646116.spcost)
	e2:SetTarget(c75646116.sptg)
	e2:SetOperation(c75646116.spop)
	c:RegisterEffect(e2)	
end
function c75646116.cfilter(c)
	return c:IsSetCard(0x62c3) and c:IsDiscardable()
end
function c75646116.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c75646116.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c75646116.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c75646116.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c75646116.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Damage(1-tp,100,0x40)
end
function c75646116.cfilter1(c)
	return c:IsSetCard(0x62c3) and c:IsAbleToGraveAsCost()
end
function c75646116.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646116.cfilter1,tp,0xc,0,1,nil) end
	Duel.Hint(3,tp,504)
	local g=Duel.SelectMatchingCard(tp,c75646116.cfilter1,tp,0xc,0,1,1,nil)
	Duel.SendtoGrave(g,0x80)
end
function c75646116.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x4)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,0x200,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,0x80000,nil,0,1-tp,100)
end
function c75646116.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,0x5)>0 then
		Duel.Damage(1-tp,100,0x40)
	end 
end