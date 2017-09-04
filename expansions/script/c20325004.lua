--穴居者 地龙
function c20325004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),3,2)
	c:EnableReviveLimit()
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20325004,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c20325004.settg)
	e2:SetOperation(c20325004.setop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c20325004.reptg)
	e3:SetOperation(c20325004.repop)
	e3:SetValue(c20325004.repval)
	c:RegisterEffect(e3)
end
function c20325004.repfilter(c,tp)
	return (c:IsFacedown() or (c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER))) and c:IsControler(tp) 
end
function c20325004.repval(e,c)
	return c20325004.repfilter(c,e:GetHandlerPlayer()) 
end
function c20325004.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c20325004.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(20325004,0))
end
function c20325004.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c20325004.setfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c20325004.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c20325004.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c20325004.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c20325004.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end