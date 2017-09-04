--时幻秘术师
function c10981042.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10981042.ffilter,c10981042.ffilter2,true)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10981042+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c10981042.copycon)
	e2:SetCost(c10981042.cost)
	e2:SetTarget(c10981042.atktg)
	e2:SetOperation(c10981042.atkop)
	c:RegisterEffect(e2)
end
function c10981042.ffilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_NORMAL) and not c:IsType(TYPE_PENDULUM)
end
function c10981042.ffilter2(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_RITUAL) 
end
function c10981042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	Duel.PayLPCost(tp,Duel.GetLP(tp)-100)
end
function c10981042.copycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION 
end
function c10981042.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c10981042.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10981042.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10981042.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
	Duel.SetTargetParam(ac)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10981042.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c10981042.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		tc:RegisterEffect(e1)
		tc:CopyEffect(ac,RESET_EVENT+0x1fe0000,1)
	end
end
