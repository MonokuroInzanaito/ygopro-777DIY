--朕命中注定统治世界
function c18781016.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,18781016)
	e4:SetCost(c18781016.cost)
	e4:SetTarget(c18781016.target)
	e4:SetOperation(c18781016.activate)
	c:RegisterEffect(e4)
end
function c18781016.filter(c,e,tp)
	return c:IsSetCard(0x6abb) and c:IsFaceup()
end
function c18781016.filter2(c,e,tp)
	return c:IsSetCard(0x3abb) and c:IsFaceup()
end
function c18781016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if chk==0 then return c>0 and Duel.IsExistingMatchingCard(c18781016.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c18781016.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c18781016.filter2,tp,LOCATION_ONFIELD,0,1,c,nil)
	e:SetLabel(g:GetCount())
end
function c18781016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	local dis=Duel.SelectDisableField(tp,e:GetLabel(),LOCATION_ONFIELD,LOCATION_ONFIELD,0)
	e:SetLabel(dis)
end
function c18781016.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c18781016.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetLabel(e:GetLabel())
	e:GetHandler():RegisterEffect(e1)
end
function c18781016.disop(e,tp)
	return e:GetLabel()
end