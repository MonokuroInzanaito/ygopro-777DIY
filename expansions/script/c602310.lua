--星刻*奥斯卡·布列斯兰德
function c602310.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,2)
	c:EnableReviveLimit()

	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x42c))
	e2:SetValue(400)
	c:RegisterEffect(e2)

	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(602310,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,602310)
	e3:SetCost(c602310.cost)
	e3:SetCondition(c602310.condition)
	e3:SetTarget(c602310.target)
	e3:SetOperation(c602310.operation)
	c:RegisterEffect(e3)
	--change2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(602310,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0+TIMING_BATTLE_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,602310)
	e4:SetCost(c602310.cost)
	e4:SetCondition(c602310.condition2)
	e4:SetTarget(c602310.target)
	e4:SetOperation(c602310.operation)
	c:RegisterEffect(e4)

end

function c602310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end

function c602310.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(602301) and not c:IsDisabled()
end

function c602310.condition(e,c)
	return not Duel.IsExistingMatchingCard(c602310.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602310.condition2(e,c)
	return Duel.IsExistingMatchingCard(c602310.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c602310.filter1,tp,0,LOCATION_SZONE,1,nil) end
end

function c602310.filter1(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end

function c602310.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 or not Duel.IsExistingMatchingCard(c602310.filter1,tp,0,LOCATION_ONFIELD,1,nil) then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(602310,2))
		ac=Duel.AnnounceNumber(tp,1,2,3)
	end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(Card.IsSetCard,nil,0x42c)
	if sg:GetCount()>0 then
		local tc=Duel.SelectMatchingCard(tp,c602310.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
		if tc:GetCount()>0 then
			local c=e:GetHandler()
			local tc2=tc:GetFirst()
			local og=tc2:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc2))
		end
	end
end

