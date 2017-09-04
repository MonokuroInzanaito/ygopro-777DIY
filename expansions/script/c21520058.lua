--强制灵子殖装
function c21520058.initial_effect(c)
	--activity
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520058,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520058+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21520058.cost)
	e1:SetTarget(c21520058.target)
	e1:SetOperation(c21520058.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(c21520058.handcon)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(21520058,ACTIVITY_CHAIN,c21520058.chainfilter)
end
function c21520058.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function c21520058.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c21520058.chainfilter(re,tp,cid)
	return re:GetHandler():IsSetCard(0x494)
end
function c21520058.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x494)
end
function c21520058.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x494)
end
function c21520058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21520058,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c21520058.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c21520058.splimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c21520058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c21520058.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21520058.filter,1-tp,LOCATION_MZONE,0,1,nil) end
--	g:GetFirst():RegisterFlagEffect(21520058,RESET_EVENT+0x1f80000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c21520058.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(1-tp,c21520058.filter,1-tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
--	tc:GetFlagEffect(21520058)~=0 and tc:IsOnField() and tc:IsRelateToEffect(e) and 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
--		tc:ResetFlagEffect(21520058)
		--Equip limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c21520058.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		--control
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EFFECT_SET_CONTROL)
		e3:SetValue(c21520058.ctval)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		--down atk & def
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(-tc:GetBaseAttack())
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UPDATE_DEFENSE)
		e5:SetValue(-tc:GetBaseDefense())
		c:RegisterEffect(e5)
		--CANNOT_TRIGGER
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_EQUIP)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e6:SetCode(EFFECT_CANNOT_TRIGGER)
		e6:SetCondition(c21520058.ctcon)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e6)
		--lose life
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetRange(LOCATION_SZONE)
		e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e7:SetCountLimit(1)
		e7:SetCondition(c21520058.llcon)
		e7:SetOperation(c21520058.llop)
		e7:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e7)
	end
end
function c21520058.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c21520058.hafilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c21520058.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c21520058.hafilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c21520058.ctcon(e)
	return e:GetHandler():GetEquipTarget():GetAttack()==0 or e:GetHandler():GetEquipTarget():GetDefense()==0
end
function c21520058.llcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520058.llop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(e:GetHandlerPlayer(),4000,REASON_RULE)
end
