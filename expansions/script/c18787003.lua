--������װ��ħ����Ů
function c18787003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3abb),5,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1870000,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c18787003.con)
	e1:SetCost(c18787003.cost)
	e1:SetTarget(c18787003.eqtg)
	e1:SetOperation(c18787003.eqop)
	c:RegisterEffect(e1)
	--remove
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(1870000,3))
	--e2:SetCategory(CATEGORY_REMOVE)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1)
	--e2:SetCost(c18787003.rmcost)
	--e2:SetTarget(c18787003.rmtg)
	--e2:SetOperation(c18787003.rmop)
	--c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c18787003.cona)
	e3:SetValue(c18787003.val)
	c:RegisterEffect(e3)
	--def
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c18787003.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,18787002)
end
function c18787003.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb) 
end
function c18787003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c18787003.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c18787003.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end   
end
function c18787003.eqlimit(e,c)
	return e:GetOwner()==c
end
function c18787003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function c18787003.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c18787003.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,fc,nil)
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<g:GetCount() then return end
	Duel.SelectOption(tp,aux.Stringid(18787003,0))
	Duel.SelectOption(1-tp,aux.Stringid(18787003,0))
	Duel.Hint(HINT_CARD,0,18781001)
	Duel.Hint(HINT_CARD,0,18781002)
	Duel.Hint(HINT_CARD,0,18781003)
	Duel.Hint(HINT_CARD,0,18781004)
	Duel.Hint(HINT_CARD,0,18781005)
	Duel.Hint(HINT_CARD,0,18781006)
	Duel.Hint(HINT_CARD,0,18781007)
	Duel.Hint(HINT_CARD,0,18781008)
	Duel.Hint(HINT_CARD,0,18781009)
	Duel.Hint(HINT_CARD,0,18781010)
	Duel.Hint(HINT_CARD,0,18781011)
	Duel.Hint(HINT_CARD,0,18781012)
	Duel.Hint(HINT_CARD,0,18781013)
	Duel.SelectOption(tp,aux.Stringid(18787003,1))
	Duel.SelectOption(1-tp,aux.Stringid(18787003,1))
	Duel.Hint(HINT_CARD,0,18787002)
	Duel.Hint(HINT_CARD,0,18787003) 
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c18787003.eqlimit)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end
function c18787003.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c18787003.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c18787003.rmfilter(c)
	return c:IsAbleToRemove()
end
function c18787003.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18787003.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SelectOption(tp,aux.Stringid(1870000,3))
	Duel.SelectOption(1-tp,aux.Stringid(1870000,3))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c18787003.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c18787003.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c18787003.cona(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE+LOCATION_SZONE)
end
function c18787003.val(e,c)
	return c:GetEquipCount()*500
end