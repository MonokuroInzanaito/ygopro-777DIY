--少女召来的少女
function c18700300.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19990008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,18700300)
	e2:SetCondition(c18700300.spcon)
	e2:SetTarget(c18700300.sptg)
	e2:SetOperation(c18700300.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45286019,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,187003000)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c18700300.tg)
	e3:SetOperation(c18700300.op)
	c:RegisterEffect(e3)
end
function c18700300.cfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:GetPreviousControler()==tp and c:IsSetCard(0xabb) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c18700300.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18700300.cfilter,1,nil,tp)
end
function c18700300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18700300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18700300.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 or (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return false end
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return false end
		local g=Duel.GetDecktopGroup(tp,4)
		local result=g:FilterCount(c18700300.filter2,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c18700300.filter2(c,tp)
	return not c:IsCode(TYPE_PENDULUM)
end
function c18700300.filter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xabb)
end
function c18700300.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,4)
	local g=Duel.GetDecktopGroup(p,4)
	local g2=g:Filter(c18700300.filter,nil)
	if g2:GetCount()>0 and not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
		local sg=g2:Select(p,1,2,nil)
			local tc1=sg:GetFirst()
			local tc2=sg:GetNext()
			Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else if g2:GetCount()>0 and ( not Duel.GetFieldCard(tp,LOCATION_SZONE,6) or not Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
		local sg=g2:Select(p,1,1,nil)
		local tc=sg:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
		end
		Duel.ShuffleDeck(p)
	end
end