--幸运之神明 卯花之佐久夜姬
function c10981092.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep==tp
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local n=select("#",Duel.GetDiceResult())
		if n<=0 then return end
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
		local t={}
		for i=1,n do
			table.insert(t,6)
		end
		Duel.SetDiceResult(table.unpack(t))
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep==tp
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local n=select("#",Duel.GetCoinResult())
		if n<=0 then return end
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
		local t={}
		for i=1,n do
			table.insert(t,1)
		end
		Duel.SetCoinResult(table.unpack(t))
	end)
	c:RegisterEffect(e2)
end