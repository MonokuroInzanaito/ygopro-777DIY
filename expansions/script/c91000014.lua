--天印-灵威仰
function c91000014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,5)
	c:EnableReviveLimit()
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91000014,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c91000014.damcost)
	e1:SetTarget(c91000014.damtg)
	e1:SetOperation(c91000014.damop)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c91000014.aop)
	c:RegisterEffect(e2)
	if not c91000014.global_check then
		c91000014.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c91000014.rop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c91000014.rfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOriginalRank()==2 and c:GetFlagEffect(91000014)==0
end
function c91000014.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c91000014.rfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local ct=tc:GetOverlayCount()
		local code=tc:GetOriginalCode()*3+1
		local e1=Effect.CreateEffect(tc)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c91000014.reop)
		e1:SetLabel(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(91000014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		tc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,0)
		tc=g:GetNext()
	end
end
function c91000014.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=e:GetLabel()
	local ct2=c:GetOverlayCount()
	if ct1==ct2 then return end
	if ct1>ct2 then
		local ct=ct1-ct2
		local code=c:GetOriginalCode()*3+1
		local lt=c:GetFlagEffectLabel(code)
		c:SetFlagEffectLabel(code,lt+ct)
	end
	e:SetLabel(ct2)
	Duel.Readjust()
end
function c91000014.afilter(c)
	local code=c:GetOriginalCode()*3+1
	return c:GetFlagEffect(code)>0 and c:IsType(TYPE_XYZ) and c:GetOriginalRank()==2
end
function c91000014.aop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c91000014.afilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()*3+1
		local ct=tc:GetFlagEffectLabel(code)
		if ct>=1 and tc:GetFlagEffect(91000114)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(aux.Stringid(91000014,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCondition(c91000014.effcon)
			e1:SetValue(c91000014.efilter)
			e1:SetLabel(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(91000114,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		if ct>=2 and tc:GetFlagEffect(91000214)==0 then
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(aux.Stringid(91000014,3))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(c91000014.effcon)
			e2:SetLabel(2)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_EXTRA_ATTACK)
			e3:SetCondition(c91000014.effcon)
			e3:SetValue(1)
			e3:SetLabel(2)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3,true)
			tc:RegisterFlagEffect(91000214,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		if ct>=3 and tc:GetFlagEffect(91000314)==0 then
			local e4=Effect.CreateEffect(tc)
			e4:SetDescription(aux.Stringid(91000014,4))
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_DAMAGE_CALCULATING)
			e4:SetCondition(c91000014.effcon)
			e4:SetOperation(c91000014.cgop)
			e4:SetLabel(3)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4,true)
			tc:RegisterFlagEffect(91000314,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		tc=g:GetNext()
	end
end
function c91000014.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()*3+1
	if c:GetFlagEffect(code)>0 then
		return c:GetFlagEffectLabel(code)>=e:GetLabel()
	else return false end
end
function c91000014.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandler():GetControler()
end
function c91000014.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()*3+1
	local ct=0
	if c:GetFlagEffect(code)>0 then
		ct=c:GetFlagEffectLabel(code)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(function(e)
		return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
	end)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ct*600)
	c:RegisterEffect(e1)
end
function c91000014.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,nil,tp,1,REASON_COST)
		and e:GetHandler():GetFlagEffect(91000414)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91000014,1))
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,nil,tp,1,REASON_COST)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	local ct=tc:GetOverlayCount()
	tc:RemoveOverlayCard(tp,1,ct,REASON_COST)
	local ct2=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct2)
	e:GetHandler():RegisterFlagEffect(91000414,RESET_CHAIN,0,1)
end
function c91000014.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*600)
end
function c91000014.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetLabel()
	Duel.Damage(p,ct*600,REASON_EFFECT)
end
