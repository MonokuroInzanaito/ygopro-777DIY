--传说之骑兵 阿喀琉斯
function c99999927.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c99999927.synfilter),aux.NonTuner(c99999927.scyfilter2),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99999927.secon)
	e1:SetTarget(c99999927.tg)
	e1:SetOperation(c99999927.op)
	c:RegisterEffect(e1)
    --indes
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c99999927.immcon)
    e2:SetValue(c99999927.indes)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(c99999927.immcon)
	e3:SetValue(c99999927.indes2)
	c:RegisterEffect(e3)
	 --special summon 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99991098,12))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c99999927.spcon)
	e4:SetOperation(c99999927.spop)
	c:RegisterEffect(e4)
	--彗星跑法
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DEFENSE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ATTACK_ALL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c99999927.actcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetValue(c99999927.aclimit)
	e7:SetCondition(c99999927.actcon2)
	c:RegisterEffect(e7)
	--翔空之星的枪尖
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetDescription(aux.Stringid(99991095,8)) 
  	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START)
	e8:SetCountLimit(1)
	e8:SetCost(c99999927.cost)
	e8:SetTarget(c99999927.sgtg)
	e8:SetOperation(c99999927.sgop)
	c:RegisterEffect(e8)
end
function c99999927.synfilter(c)
	return  c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)
end
function c99999927.scyfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c99999927.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c99999927.sefilter(c)
	local code=c:GetCode()
	return (code==99999993) 
end
function c99999927.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999927.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99999927.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local  g1=Duel.SelectMatchingCard(tp,c99999927.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc1=g1:GetFirst()
	if tc1  then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
			and (not tc1:IsAbleToHand()  or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
				if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc1,c)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc1)
			
		end
end
end
function c99999927.immcon(e)
 return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c99999927.indes(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsType(TYPE_XYZ) then 
	return c:GetRank()<=lv
	else 
	return c:GetLevel()<=lv
end
end
function c99999927.indes2(e,te)
    if te:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) or  te:GetOwnerPlayer()~=e:GetHandlerPlayer() then return end
	local lv=e:GetHandler():GetLevel()
	if te:GetHandler():IsType(TYPE_XYZ) then 
	return te:GetHandler():GetRank()<=lv
	else 
	return te:GetHandler():GetLevel()<=lv
end
end
function c99999927.spfilter1(c,tp)
    local lv
	if c:GetLevel()>0 then
	lv=c:GetLevel()
	end
	return (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)) and c:IsAbleToGraveAsCost() 
	and Duel.IsExistingMatchingCard(c99999927.spfilter2,tp,LOCATION_MZONE,0,1,c,lv)
end
function c99999927.spfilter2(c,lv)
	return (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7))  and c:IsAbleToGraveAsCost()
	and c:GetLevel()==lv
end
function c99999927.spfilter3(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)  and c:IsAbleToGraveAsCost() 
end
function c99999927.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c99999927.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c99999927.spfilter3,tp,LOCATION_HAND,0,1,nil)
end
function c99999927.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c99999927.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local lv
	if g1:GetFirst():GetLevel()>0 then
	lv=g1:GetFirst():GetLevel()
	end
	local g2=Duel.SelectMatchingCard(tp,c99999927.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),lv)
	local g3=Duel.SelectMatchingCard(tp,c99999927.spfilter3,tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c99999927.actcon(e)
	return  e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c99999927.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99999927.actcon2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
	and e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c99999927.sgfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c99999927.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999927.sgfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c99999927.sgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99999927.posfilter(c)
	return c:IsPosition(POS_FACEUP_DEFENSE)
end
function c99999927.filter(c)
	return not c:IsDisabled() and c:IsFaceup()
end
function c99999927.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return (Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
	and Duel.IsExistingMatchingCard(c99999927.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil))
    or Duel.IsExistingTarget(c99999927.posfilter,tp,0,LOCATION_MZONE,1,nil) 	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	if not g:GetFirst():IsPosition(POS_FACEUP_ATTACK) then Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0) end
	local tg=Duel.GetMatchingGroup(c99999927.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,tg:GetCount(),0,0) 
end
function c99999927.sgop(e,tp,eg,ep,ev,re,r,rp)
	   local tc=Duel.GetFirstTarget()
	   local tg1=Duel.GetMatchingGroup(c99999927.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	   if tg1:GetCount()>0 then
	   local cg1=tg1:GetFirst()
	    while cg1 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		cg1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		cg1:RegisterEffect(e2)
		cg1=tg1:GetNext()
	end
	if  not tc:IsPosition(POS_FACEUP_ATTACK) then Duel.ChangePosition(tc,POS_FACEUP_ATTACK) end
	    local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_MUST_ATTACK)
		e8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e8)
		local e9=Effect.CreateEffect(e:GetHandler())
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_MUST_ATTACK)
		e9:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e9)
		local e3=Effect.CreateEffect(e:GetHandler())
	    e3:SetType(EFFECT_TYPE_FIELD)
	    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	    e3:SetTargetRange(1,1)
	    e3:SetValue(aux.TRUE)
	    e3:SetReset(RESET_PHASE+PHASE_BATTLE)
	    Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
	    e4:SetType(EFFECT_TYPE_FIELD)
	    e4:SetCode(EFFECT_CANNOT_ATTACK)
	    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
     	e4:SetTargetRange(LOCATION_MZONE,0)
	    e4:SetLabel(e:GetHandler():GetFieldID())
   	    e4:SetTarget(c99999927.filter2)
	    e4:SetReset(RESET_PHASE+PHASE_BATTLE)
	    e4:SetValue(aux.TRUE)
	    Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetTargetRange(0,LOCATION_MZONE)
		e6:SetLabel(tc:GetFieldID())
		Duel.RegisterEffect(e6,tp)
		local e7=e4:Clone()
		e7:SetTargetRange(0,LOCATION_MZONE)
		e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e7:SetLabel(tc:GetFieldID())
		Duel.RegisterEffect(e7,tp)
		
		end
	end
function c99999927.filter2(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
