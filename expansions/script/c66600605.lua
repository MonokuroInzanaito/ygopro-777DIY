--6th-恶孽医师
function c66600605.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151401,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c66600605.sptg)
	e1:SetOperation(c66600605.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66600605,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c66600605.atktg)
	e2:SetOperation(c66600605.atkop)
	c:RegisterEffect(e2)
	 --draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66600605,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_MZONE)
   e3:SetType(EFFECT_TYPE_QUICK_O)
   e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetCondition(c66600605.drcon)
	e3:SetTarget(c66600605.drtg)
	e3:SetOperation(c66600605.drop)
	c:RegisterEffect(e3)
	--
	 local e4=Effect.CreateEffect(c)
	e4:SetRange(LOCATION_MZONE)
   e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e4:SetCode(EVENT_CHAINING)
   e4:SetCondition(c66600605.flcon)
	e4:SetOperation(c66600605.flop)
	c:RegisterEffect(e4)
end
function c66600605.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e) and c:IsAbleToRemove()
end
function c66600605.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66600605.refilter(chkc) and chkc:IsControler(tp) end
	 if chk==0 then return Duel.IsExistingTarget(c66600605.refilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c66600605.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66600605.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c66600605.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x66e)
end
function c66600605.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c66600605.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c66600605.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66600605.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66600605.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c66600605.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66600605)>0 
end
function c66600605.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66600605.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66600605.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())  
end
function c66600605.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66600605,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end