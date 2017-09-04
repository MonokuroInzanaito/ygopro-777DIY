--龙舞姬*艾克
function c602307.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x42c),1,2)
	c:EnableReviveLimit()

	-- Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(602307,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60230701)
	e1:SetCondition(c602307.spcon)
	e1:SetOperation(c602307.spop)
	e1:SetValue(SUMMON_TYPE_SPECIAL)
	c:RegisterEffect(e1)

	--change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(602307,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,60230702)
	e2:SetCost(c602307.cost)
	e2:SetCondition(c602307.condition)
	e2:SetTarget(c602307.target)
	e2:SetOperation(c602307.operation)
	c:RegisterEffect(e2)
	--change2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(602307,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_BATTLE_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,60230702)
	e3:SetCost(c602307.cost)
	e3:SetCondition(c602307.condition2)
	e3:SetTarget(c602307.target)
	e3:SetOperation(c602307.operation)
	c:RegisterEffect(e3)

	--can't XyzSummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end

function c602307.filter(c,e,tp)
	return c:IsSetCard(0x42c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c602307.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,602302) 
		 and Duel.IsExistingMatchingCard(c602307.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
			 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0
end

function c602307.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c602307.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c602307.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		sg:Merge(g)
	end
end

function c602307.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c602307.cfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==(602301) and not c:IsDisabled()
end

function c602307.condition(e,c)
	return not Duel.IsExistingMatchingCard(c602307.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602307.condition2(e,c)
	return Duel.IsExistingMatchingCard(c602307.cfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c602307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

function c602307.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		--atk up
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(g:GetCount()*200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end





