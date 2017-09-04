--基础图腾
local m=32822011
local cm=_G["c"..m]
if not orion or not orion.totem then
	if not pcall(function() require("expansions/script/c32822000") end) then require("script/c32822000") end
end
function cm.initial_effect(c)
	local e1=nil
	--pendulum initial
	orion.totemInitial(c,true,false)
	--copy pendulum
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(orion.plantPendulum,tp,LOCATION_HAND,0,1,nil) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not Duel.IsExistingMatchingCard(orion.plantPendulum,tp,LOCATION_HAND,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,orion.plantPendulum,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetCount()>0 then
			local tc=g:GetFirst()
			local code=tc:GetOriginalCode()
			local ls=tc:GetLeftScale()
			local rs=tc:GetRightScale()
			local attr=tc:GetAttribute()
			--cooy left scala
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(ls)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			c:RegisterEffect(e1)
			--copy right scala
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			e2:SetValue(rs)
			c:RegisterEffect(e2)
			--copy attribute
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_ATTRIBUTE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_PZONE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e3:SetLabelObject(e2)
			e3:SetValue(attr)
			c:RegisterEffect(e3)
			--copy effect
			local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(m,1))
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_PHASE+PHASE_END+RESET_OPPO_TURN)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetRange(LOCATION_PZONE)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e4:SetCountLimit(1)
			e4:SetLabel(cid)
			e4:SetLabelObject(e3)
			e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local cid=e:GetLabel()
				c:ResetEffect(cid,RESET_COPY)
				local e3=e:GetLabelObject()
				local e2=e3:GetLabelObject()
				local e1=e2:GetLabelObject()
				e1:Reset()
				e2:Reset()
				e3:Reset()
				Duel.HintSelection(Group.FromCards(c))
				Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
			end)
			c:RegisterEffect(e4)
		end
	end)
	c:RegisterEffect(e1)
	--search
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(orion.totemSearchAllFilter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,orion.totemSearchAllFilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(function(e,re,tp)
				return not orion.isTotem(re:GetHandler())
			end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end)
	c:RegisterEffect(e1)
	--copy monster
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(orion.plant,tp,LOCATION_HAND,0,1,nil) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not Duel.IsExistingMatchingCard(orion.plant,tp,LOCATION_HAND,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,orion.plant,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetCount()>0 then
			local tc=g:GetFirst()
			local code=tc:GetOriginalCode()
			local ba=tc:GetBaseAttack()
			local bd=tc:GetBaseDefense()
			local attr=tc:GetAttribute()
			--copy base attack
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(ba)
			c:RegisterEffect(e1)
			--copy base defense
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e2:SetLabelObject(e1)
			e2:SetValue(bd)
			c:RegisterEffect(e2)
			--copy attribute
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_ATTRIBUTE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e3:SetLabelObject(e2)
			e3:SetValue(attr)
			c:RegisterEffect(e3)
			--copy effect
			local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			--reset copy
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(m,4))
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_PHASE+PHASE_END+RESET_OPPO_TURN)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e4:SetCountLimit(1)
			e4:SetLabel(cid)
			e4:SetLabelObject(e3)
			e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local cid=e:GetLabel()
				c:ResetEffect(cid,RESET_COPY)
				local e3=e:GetLabelObject()
				local e2=e3:GetLabelObject()
				local e1=e2:GetLabelObject()
				e1:Reset()
				e2:Reset()
				e3:Reset()
				Duel.HintSelection(Group.FromCards(c))
				Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
			end)
			c:RegisterEffect(e4)
			--specidal deal
			local regs={
				[32822001]=orion.totemStoneclawReg,
				[32822002]=orion.totemHealingStreamReg,
				[32822003]=orion.totemEchoReg,
				[32822004]=orion.totemFlameReg,
				[32822012]=orion.totemNatureResistanceReg 
			}
			for index,reg in pairs(regs) do
				if code==index then
					local e1=nil
					--effect reg
					e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_BE_MATERIAL)
					e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					e1:SetOperation(reg)
					c:RegisterEffect(e1)
				end
			end
		end
	end)
	c:RegisterEffect(e1)
end
