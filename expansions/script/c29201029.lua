--镜世录 作祟神
function c29201029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x63e0),6,2)
	c:EnableReviveLimit()
	--halve damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c29201029.condition)
	e2:SetValue(c29201029.val)
	c:RegisterEffect(e2)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29201029,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c29201029.descost)
	e1:SetTarget(c29201029.destg)
	e1:SetOperation(c29201029.desop)
	c:RegisterEffect(e1)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29201029,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,29201029)
	e4:SetCondition(c29201029.sumcon)
	e4:SetTarget(c29201029.sumtg)
	e4:SetOperation(c29201029.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function c29201029.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29201029.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c29201029.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c29201029.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x63e0) and c:IsType(TYPE_MONSTER) 
end
function c29201029.condition(e)
	return Duel.IsExistingMatchingCard(c29201029.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c29201029.val(e,re,dam,r,rp,rc)
	return math.ceil(dam/2)
end
function c29201029.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c29201029.filter(c,e,tp)
	return c:IsSetCard(0x63e0) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29201029.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29201029.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29201029.matfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
function c29201029.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.SelectTarget(tp,c29201029.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if tg and Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local tc1=tg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		local g=Duel.SelectMatchingCard(tp,c29201029.matfilter,tp,LOCATION_SZONE,0,1,99,nil)
		if Duel.SelectYesNo(tp,aux.Stringid(29201029,2)) and g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.Overlay(tc1,g)
			--[[local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(tc1,mg)
			end
			Duel.Overlay(tc1,Group.FromCards(tc))]]
			tc=g:GetNext()
			end
		end
	end
end

