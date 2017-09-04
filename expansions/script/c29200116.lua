--凋叶棕-绝对的一方通行
function c29200116.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200116,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c29200116.cpcost)
	e2:SetTarget(c29200116.cptg)
	e2:SetOperation(c29200116.cpop)
	c:RegisterEffect(e2)
	--splimit
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_PZONE)
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetTargetRange(1,0)
	e12:SetCondition(c29200116.splimcon)
	e12:SetTarget(c29200116.splimit)
	c:RegisterEffect(e12)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c29200116.target)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--tohand
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(29200116,0))
	e10:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e10:SetCode(EVENT_BE_MATERIAL)
	e10:SetCondition(c29200116.condition)
	e10:SetTarget(c29200116.rectg)
	e10:SetOperation(c29200116.recop)
	c:RegisterEffect(e10)
end
function c29200116.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end
function c29200116.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c29200116.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Recover(p,600,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end
end
function c29200116.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c29200116.target(e,c)
	return Duel.IsExistingMatchingCard(c29200116.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function c29200116.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c29200116.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x53e0) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29200116.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(29200116)==0 end
	e:GetHandler():RegisterFlagEffect(29200116,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c29200116.cpfilter(c)
	return c:IsSetCard(0x53e0) and c:IsType(TYPE_MONSTER) and not c:IsCode(29200116)
end
function c29200116.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c29200116.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29200116.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c29200116.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c29200116.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
	end
end
