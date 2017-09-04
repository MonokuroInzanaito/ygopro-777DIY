--泠雪
function c18781004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18781004,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e3:SetCountLimit(1,18781004)
	e3:SetCondition(c18781004.condition)
	e3:SetTarget(c18781004.sptg)
	e3:SetOperation(c18781004.spop)
	c:RegisterEffect(e3)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18781004,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,18781004)
	e1:SetCost(c18781004.cost)
	e1:SetTarget(c18781004.target)
	e1:SetOperation(c18781004.operation)
	c:RegisterEffect(e1)
end
function c18781004.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c18781004.ccfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c18781004.ccfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6abb) and c:IsType(TYPE_XYZ)
end
function c18781004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2 end
end
function c18781004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c18781004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18781004.filter2(c)
	return c:IsFacedown() or c:IsAttackPos()
end
function c18781004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c18781004.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENSE)
	local sg=Duel.GetMatchingGroup(c18781004.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,1,0,0)
end
function c18781004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if sg then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	end
end