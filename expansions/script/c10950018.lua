--卒業おめでとう
function c10950018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c10950018.target)
	e1:SetOperation(c10950018.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(c10950018.target2)
	e2:SetOperation(c10950018.activate2)
	c:RegisterEffect(e2)
end
function c10950018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,29,REASON_EFFECT) and Duel.GetFlagEffect(tp,10950014)==0 end
	Duel.RemoveCounter(tp,1,0,0x13ac,29,REASON_EFFECT)
end
function c10950018.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x13ac,7,REASON_EFFECT) and Duel.GetFlagEffect(tp,10950014)~=0 end
	Duel.RemoveCounter(tp,1,0,0x13ac,7,REASON_EFFECT)
end
function c10950018.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsCanRemoveCounter(tp,1,0,0x13ac,29,REASON_EFFECT) then return end
	Duel.RemoveCounter(tp,1,0,0x13ac,29,REASON_EFFECT)
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,0))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,2))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,3))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,4))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,5))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,6))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,7))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,8))
	Duel.SetLP(1-tp,0)
end
function c10950018.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsCanRemoveCounter(tp,1,0,0x13ac,7,REASON_EFFECT) then return end
	Duel.RemoveCounter(tp,1,0,0x13ac,7,REASON_EFFECT)
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,0))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,2))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,3))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,4))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,5))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,6))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,7))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10950018,8))
	Duel.SetLP(1-tp,0)
end