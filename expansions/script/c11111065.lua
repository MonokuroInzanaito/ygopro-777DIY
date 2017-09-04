--加油大魔王 苦涩的潘
function c11111065.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c11111065.sumop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111065,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11111065)
	e2:SetTarget(c11111065.target)
	e2:SetOperation(c11111065.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c11111065.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,11111065)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15d))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,11111065,RESET_PHASE+PHASE_END,0,1)
end
function c11111065.lvfilter(c)
	return c:IsSetCard(0x15d) and c:GetLevel()==8
end
function c11111065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11111065.lvfilter,tp,LOCATION_HAND,0,1,nil)
	local b2=e:GetHandler():GetLevel()~=8
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(11111065,1),aux.Stringid(11111065,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(11111065,1))
	else op=Duel.SelectOption(tp,aux.Stringid(11111065,2))+1 end
	e:SetLabel(op)
end
function c11111065.afilter(c,code)
	return c:IsCode(code)
end
function c11111065.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c11111065.lvfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local hg=Duel.GetMatchingGroup(c11111065.afilter,tp,LOCATION_HAND,0,nil,g:GetFirst():GetCode())
		local tc=hg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-4)
			e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=hg:GetNext()
		end
	else	
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(8)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
		end
		if Duel.GetFlagEffect(tp,111110650)==0 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(11111065,3))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetTargetRange(LOCATION_HAND,0)
			e3:SetCode(EFFECT_SUMMON_PROC)
			e3:SetCountLimit(1)
			e3:SetCondition(c11111065.ntcon)
			e3:SetTarget(c11111065.nttg)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			Duel.RegisterFlagEffect(tp,111110650,RESET_PHASE+PHASE_END,0,1)
		end
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(c11111065.actlimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c11111065.attg)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c11111065.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c11111065.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x15d)
end
function c11111065.attg(e,c)
	return not c:IsType(TYPE_XYZ)
end
function c11111065.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x15d) and not rc:IsImmuneToEffect(e)
end