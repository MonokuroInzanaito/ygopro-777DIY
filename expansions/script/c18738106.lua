--闇堕的咒缚
function c18738106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18738106+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c18738106.cost)
	e1:SetTarget(c18738106.target)
	e1:SetOperation(c18738106.activate)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c18738106.negcon)
	e2:SetCost(c18738106.setcost)
	e2:SetOperation(c18738106.setop)
	c:RegisterEffect(e2)
end
function c18738106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xab0) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xab0)
	Duel.Release(g,REASON_COST)
end
function c18738106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738106.sfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18738106.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18738106.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c18738106.sfilter(c)
	return c:IsSetCard(0xab0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c18738106.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c18738106.setfilter(c)
	return c:IsSetCard(0xab0) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c18738106.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18738106.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18738106.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c18738106.setop(e,tp,eg,ep,ev,re,r,rp)
	--disable&destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c18738106.distg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SELF_DESTROY)
	Duel.RegisterEffect(e2,tp)
	--disable effect
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c18738106.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(1)
	Duel.RegisterEffect(e4,tp)
end
function c18738106.distg(e,c)
	if c:GetCardTargetCount()==0 then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil 
end
function c18738106.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil then
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) then
			Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end