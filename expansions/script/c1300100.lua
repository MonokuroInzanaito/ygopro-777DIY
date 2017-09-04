--虚拟歌姬的延续
function c1300100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c1300100.target)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
--  e2:SetDescription(aux.Stringid(1300100,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1300100)
	e2:SetCondition(c1300100.rcon)
	e2:SetTarget(c1300100.rtg)
	e2:SetOperation(c1300100.rop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
--  e3:SetDescription(aux.Stringid(1300100,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(0x14000)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,1300101)
	e3:SetCondition(c1300100.sgcon)
	e3:SetTarget(c1300100.sgtg)
	e3:SetOperation(c1300100.sgop)
	c:RegisterEffect(e3)
end
function c1300100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c1300100.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c1300100.rtg(e,tp,eg,ep,ev,re,r,rp,0)
	if b1 and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		Duel.RegisterFlagEffect(tp,1300101,RESET_PHASE+PHASE_END,0,1)
		e:SetOperation(c1300100.rop)
		c1300100.rtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c1300100.rcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1300101)==0
end
function c1300100.rfilter(c)
	if not c:IsAbleToRemove() then return false end
	return c:IsLocation(LOCATION_MZONE) or c:IsType(TYPE_MONSTER)
end
function c1300100.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c1300100.rfilter(chkc) end
	local f=function(c)
		return c:IsSetCard(0x130) and c:IsAbleToDeckOrExtraAsCost()
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c1300100.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(f,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,f,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c1300100.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1300100.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		c:RegisterFlagEffect(1300100,RESET_EVENT+0x1660000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp)
			return Duel.GetTurnPlayer()==tp
		end)
		e1:SetOperation(c1300100.retop)
		Duel.RegisterEffect(e1,tp)
	end
 end
function c1300100.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsPreviousLocation(LOCATION_GRAVE) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
	tc:ResetFlagEffect(1300100)
end
 function c1300100.sgcon(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler()==e:GetHandler() then return false end
	return bit.band(r,REASON_EFFECT)==REASON_EFFECT
end
function c1300100.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c1300100.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
 end
 