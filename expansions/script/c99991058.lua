--天使之诗
function c99991058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,99991058+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99991058.target)
	e1:SetOperation(c99991058.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99991058,ACTIVITY_SPSUMMON,c99991058.counterfilter)
end
function c99991058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99991056,0,0x4011,1000,1000,3,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99991058.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99991056,0,0x4011,1000,1000,3,RACE_FAIRY,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,99991056)
			if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.SpecialSummonComplete()
			local t={aux.Stringid(99991058,0),aux.Stringid(99991058,1),aux.Stringid(99991058,2),aux.Stringid(99991058,3)}
	        local p=1 
	        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99991058,4))	
     		local sel=Duel.SelectOption(tp,table.unpack(t))+1
			local opt=t[sel]-aux.Stringid(99991058,0)
	        local sg=nil
	        if opt==0 then 
			--atk
	        local e1=Effect.CreateEffect(e:GetHandler())
	        e1:SetDescription(aux.Stringid(99991058,0))
	        e1:SetCategory(CATEGORY_ATKCHANGE)
       	    e1:SetType(EFFECT_TYPE_QUICK_O)
	        e1:SetCode(EVENT_FREE_CHAIN)
	        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
			e1:SetHintTiming(TIMING_DAMAGE_STEP)
	        e1:SetRange(LOCATION_MZONE)
	        e1:SetCountLimit(1)
			e1:SetCondition(c99991058.con)
	        e1:SetTarget(c99991058.tg1)
	        e1:SetOperation(c99991058.op1)
	        e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1)
	        elseif opt==1 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(99991058,1))
	        e1:SetCategory(CATEGORY_DESTROY)
       	    e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetHintTiming(0,0x1e0)
	        e1:SetCode(EVENT_FREE_CHAIN)
	        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET)
	        e1:SetRange(LOCATION_MZONE)
			e1:SetCost(c99991058.cost)
            e1:SetTarget(c99991058.tg2)
	        e1:SetOperation(c99991058.op2)
	        e1:SetReset(RESET_EVENT+0x1fe000)
			token:RegisterEffect(e1)
	        elseif opt==2 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(99991058,2))
	        e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
       	    e1:SetType(EFFECT_TYPE_QUICK_O)
	        e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(0,0x1e0)
	        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	        e1:SetRange(LOCATION_MZONE)
	        e1:SetCountLimit(1)
			e1:SetCost(c99991058.cost2)
            e1:SetTarget(c99991058.tg3)
	        e1:SetOperation(c99991058.op3)
	        e1:SetReset(RESET_EVENT+0x1fe000)
			token:RegisterEffect(e1)
			elseif opt==3 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(99991058,3))
	        e1:SetCategory(CATEGORY_DISABLE)
       	    e1:SetType(EFFECT_TYPE_QUICK_O)
	        e1:SetCode(EVENT_FREE_CHAIN)
	        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET)
	        e1:SetRange(LOCATION_MZONE)
			e1:SetHintTiming(0,0x1e0)
	        e1:SetCountLimit(1)
			e1:SetCost(c99991058.cost2)
            e1:SetTarget(c99991058.tg4)
	        e1:SetOperation(c99991058.op4)
	        e1:SetReset(RESET_EVENT+0x1fe000)
			token:RegisterEffect(e1)
	     end
	end
end
end
function c99991058.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c99991058.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c99991058.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(400)
		tc:RegisterEffect(e1)
	end
end
function c99991058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c99991058.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and 
	Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c99991058.op2(e,tp,eg,ep,ev,re,r,rp)
  	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c99991058.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)
end
function c99991058.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsReleasable() and Duel.GetCustomActivityCount(99991058,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99991058.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c99991058.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY))
end
function c99991058.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end

function c99991058.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99991058.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99991058.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c99991058.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil,e,tp)
	if Duel.SpecialSummonStep(tc:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:GetFirst():RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:GetFirst():RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c99991058.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c99991058.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and  chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99991058.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCondition(c99991058.poscon)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_ATTACK)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c99991058.poscon(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end

