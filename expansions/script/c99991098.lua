--虚荣的空中庭院
function c99991098.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99991098.condition)
	e1:SetCost(c99991098.cost)
	e1:SetTarget(c99991098.target)
	e1:SetOperation(c99991098.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,99991099))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c99991098.imfilter)
	c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetTarget(c99991098.splimit)
	c:RegisterEffect(e7)
	--send to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(99991096,0))
	e8:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCost(c99991098.sgcost)
	e8:SetTarget(c99991098.sgtg)
	e8:SetOperation(c99991098.sgop)
	c:RegisterEffect(e8)
	--Negate
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e9:SetCondition(c99991098.negcon)
	e9:SetCost(c99991098.sgcost)
	e9:SetTarget(c99991098.negtg)
	e9:SetOperation(c99991098.negop)
	c:RegisterEffect(e9)
	--token
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PHASE+PHASE_END)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(c99991098.tkcon)
	e10:SetTarget(c99991098.tktg)
	e10:SetOperation(c99991098.tkop)
	c:RegisterEffect(e10)
	--selfdes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_SELF_DESTROY)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCondition(c99991098.sfcon)
	c:RegisterEffect(e11)
	--destroy
    local e12=Effect.CreateEffect(c)
    e12:SetCategory(CATEGORY_DESTROY)
    e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e12:SetCode(EVENT_LEAVE_FIELD)
    e12:SetTarget(c99991098.destg)
    e12:SetOperation(c99991098.desop)
    c:RegisterEffect(e12)   
end
function c99991098.dfilter(c)
	return not (c:IsCode(99991099) or c:IsType(TYPE_TOKEN))
end
function c99991098.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2 
	    and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c99991098.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99991098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c99991098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99991096,0,0x4011,2000,2000,4,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c99991098.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) 
	    or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,99991096,0,0x4011,2000,2000,4,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local token1=Duel.CreateToken(tp,99991096)
    Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
	local token2=Duel.CreateToken(tp,99991096)
	Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
function c99991098.imfilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c99991098.splimit(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function c99991098.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,99991096) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,99991096)
	Duel.Release(g,REASON_COST)
end
function c99991098.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99991096,1))
	local g0=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g0:GetFirst()
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) then
        local g=Group.FromCards(tc)  
	    dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
		if dc then g:AddCard(dc) end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	elseif tc:IsLocation(LOCATION_SZONE) and seq<5 then
		local g=Group.FromCards(tc)
		dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
		if dc then g:AddCard(dc) end
	    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
	end	
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
	    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	end	
end
function c99991098.sgop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end 
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsRelateToEffect(e) then 
		if tc:IsLocation(LOCATION_MZONE) then
			local g=Group.FromCards(tc)  
			dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
			if dc then g:AddCard(dc) end
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif tc:IsLocation(LOCATION_SZONE) and seq<5 then
			local g=Group.FromCards(tc)
			dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
			if dc then g:AddCard(dc) end
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end	
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
			Duel.BreakEffect()
			local cg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
			local sg=cg:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end	
	end	
end
function c99991098.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
end
function c99991098.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99991098.negop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c99991098.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99991098.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99991098.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)
	    or Duel.GetLocationCount(tp,LOCATION_MZONE)<1
	    or not Duel.IsPlayerCanSpecialSummonMonster(tp,99991096,0,0x4011,2000,2000,4,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,99991096)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c99991098.sfcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,99991099)
end
function c99991098.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsDestrutable() end 
	if chk==0 then return true end 
	local g=Duel.GetMatchingGroup(Card.IsDestrutable,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99991098.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDestrutable,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end