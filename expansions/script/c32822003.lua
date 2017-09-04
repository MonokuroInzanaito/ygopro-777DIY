--回音图腾
local m=32822003
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)
	local e1=nil
	--pendulum initial
	orion.totemInitial(c,true,true)
	--pendulum set
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local seq=e:GetHandler():GetSequence()
		if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) and Duel.IsExistingMatchingCard(orion.totemPendulumNotForbiddenFilter,tp,LOCATION_DECK,0,1,nil) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local seq=c:GetSequence()
		if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,orion.totemPendulumNotForbiddenFilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=nil
			e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return eg:IsExists(orion.isSummonPlayer,1,nil,tp) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
			end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			--sp_summon effect
			e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return eg:IsExists(orion.isSummonPlayer,1,nil,tp) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
			end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetFlagEffect(tp,m)>0
			end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local n=Duel.GetFlagEffect(tp,m)
				Duel.ResetFlagEffect(tp,m)
				Duel.Draw(1-tp,n,REASON_EFFECT)
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end)
	c:RegisterEffect(e1)
	--change target
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not orion.totemFaceupFilter(re:GetHandler()) then return false end
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if not g or g:GetCount()~=1 then return false end
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		return tc:IsOnField()
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local tf=re:GetTarget()
		local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
		if chkc then return chkc:IsOnField() and orion.filterTf(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
		if chk==0 then return Duel.IsExistingTarget(orion.filterTf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,orion.filterTf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.ChangeTargetCard(ev,Group.FromCards(tc))
		end
	end)
	c:RegisterEffect(e1)
	--effect reg
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(orion.totemEchoReg)
	c:RegisterEffect(e1)
end