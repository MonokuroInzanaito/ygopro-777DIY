--战术人形行动·失温症
function c75010012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75010012)
	e1:SetCondition(c75010012.condition)
	e1:SetOperation(c75010012.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75010012,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,75011012)
	e2:SetCost(c75010012.dmcost)
	e2:SetCondition(c75010012.dmcon)
	e2:SetTarget(c75010012.dmtg)
	e2:SetOperation(c75010012.dmop)
	c:RegisterEffect(e2)
end
function c75010012.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x520) and c:IsType(TYPE_MONSTER)
end
function c75010012.condition(e)
	return Duel.IsExistingMatchingCard(c75010012.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c75010012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c75010012.btcon)
	e1:SetOperation(c75010012.btop)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75010012.btcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttacker():IsSetCard(0x520)
end
function c75010012.btop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75010012)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function c75010012.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c75010012.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75010012.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75010012.filter(c,e,tp)
	return c:IsSetCard(0x520) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c75010012.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil and Duel.GetAttacker():IsSetCard(0x520)
end
function c75010012.dmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c75010012.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		Duel.SpecialSummon(tg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tg:GetFirst():CompleteProcedure()
	end
	local g=Group.CreateGroup()
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsCanAddCounter(0x520,1) and tc:IsSetCard(0x520) then
			tc:AddCounter(0x520,1)
		end
	end
end