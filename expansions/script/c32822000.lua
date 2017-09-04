--orion qq:455168247
--specially for totem
if not orion then
	if not pcall(function() require("expansions/script/c32800000") end) then require("script/c32800000") end
end
local cm=orion
cm.totem = 0x822
function cm.totemInitial(c,isPendulum,isSummonIndestructable)
	--default value
	if isPendulum==nil then
		idPendulum=false
	end
	if isSummonIndestructable==nil then
		isSummonIndestructable=false
	end
	--pendulum initial
	if isPendulum then
		--pendulum summon
		aux.EnablePendulumAttribute(c)
		--splimit
		cm.totemRegisterSplimit(c)   
	end
	if isSummonIndestructable then
		cm.registerSummonIndestructable(c)
		cm.registerSummonReflectDamage(c)
	end
end

-- filter
function cm.isTotem(c)
	return c:IsSetCard(cm.totem) or c:IsCode(56346071) or c:IsCode(71068247)
end
function cm.monsterFaceupNotTotem(c)
	return not cm.isTotem(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.totemSearchAllFilter(c)
	return cm.isTotem(c) and c:IsAbleToHand()
end
function cm.totemSearchMonsterFilter(c)
	return cm.isTotem(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.totemSearchSpellAndTrapFilter(c)
	return cm.isTotem(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.totemEarthFilter(c)
	return cm.isTotem(c) and bit.band(c:GetAttribute(),ATTRIBUTE_EARTH)~=0
end
function cm.totemWaterFilter(c)
	return cm.isTotem(c) and bit.band(c:GetAttribute(),ATTRIBUTE_WATER)~=0
end
function cm.totemWindFilter(c)
	return cm.isTotem(c) and bit.band(c:GetAttribute(),ATTRIBUTE_WIND)~=0
end
function cm.totemFireFilter(c)
	return cm.isTotem(c) and bit.band(c:GetAttribute(),ATTRIBUTE_FIRE)~=0
end
function cm.totemPendulumNotForbiddenFilter(c)
	return cm.isTotem(c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.totemPendulumToHandFilter(c)
	return cm.isTotem(c) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function cm.totemFaceupFilter(c)
	return cm.isTotem(c) and c:IsFaceup()
end
function cm.totemSummonFilter(c)
	return cm.isTotem(c) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function cm.plant(c)
	return c:IsRace(RACE_PLANT)
end
function cm.plantPendulum(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_PENDULUM)
end
function cm.totemReplaceFilter(c,tp)
	return cm.isTotem(c) and c:IsFaceup() and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function cm.totemEffectReplaceMonsterFilter(c,tp)
	return cm.totemReplaceFilter(c,tp) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function cm.totemEchoFilter(c,fid)
	return c:GetFlagEffectLabel(32822003)==fid
end
function cm.totemTarget(e,c)
	return cm.isTotem(c)
end
function cm.plantSpsummonFilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.totemDestroyCost(tp)
	Duel.BreakEffect()
	if not Duel.IsExistingMatchingCard(cm.isTotem,tp,LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.isTotem,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

-- register
function cm.totemRegisterSplimit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
		return not c:IsRace(RACE_PLANT) and not orion.isTotem(c) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end)
	c:RegisterEffect(e1)
end

-- condition
function cm.totemConditionHasAnotherTotem(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.totemFaceupFilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end

-- cost


-- target
function cm.totemTargetSummon(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.totemSummonFilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

-- operation
function cm.totemOperationSummon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.totemSummonFilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function cm.totemStoneclawReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=nil
	--indestructable
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822001,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(1)
	rc:RegisterEffect(e1)
	--atk limit
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822001,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(orion.valueNotItself)
	rc:RegisterEffect(e1)
	--make atk & def down
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822001,3))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local tc=e:GetHandler():GetBattleTarget()
		if chk==0 then return tc and tc:IsControler(1-tp) and (tc:GetAttack()~=0 or tc:GetDefense()~=0) end
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,tc,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetHandler():GetBattleTarget()
		if tc:IsRelateToBattle() then
			local e1=nil 
			e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
			e1=Effect.Clone(e1)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e1)
		end
	end)
	rc:RegisterEffect(e1)
end
function cm.totemHealingStreamReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=nil
	--atk down
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822002,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-rc:GetBaseAttack()/2)
	rc:RegisterEffect(e1)
	--攻击力0的对方场上的怪兽破坏。
	--destroy
	--e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetCode(EFFECT_SELF_DESTROY)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetTargetRange(0,LOCATION_MZONE)
	--e1:SetReset(RESET_EVENT+0x1fe0000)
	--e1:SetTarget(function(e,c)
	--  return c:IsAttackBelow(0) and c:IsFaceup() and not c:IsImmuneToEffect(e)
	--end)
	--e1:SetValue(aux.TRUE)
	--rc:RegisterEffect(e1)
	--disable
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822002,2))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local tc=e:GetHandler():GetBattleTarget()
		if chk==0 then return tc and tc:IsControler(1-tp) end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetHandler():GetBattleTarget()
		if tc:IsRelateToBattle() then
			local e1=nil 
			e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			e1=Effect.Clone(e1)
			e1:SetCode(EFFECT_DISABLE_EFFECT)
			e1:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e1)
		end
	end)
	rc:RegisterEffect(e1)
end
function cm.totemEchoReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=nil
	--indestructable
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822003,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(1)
	rc:RegisterEffect(e1)
	--cannot target
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(aux.tgoval)
	rc:RegisterEffect(e1)
	--effect reg
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822003,3))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local rc=c:GetReasonCard()
		local e1=nil
		--summon success
		e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(32822003,3))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(orion.plantSpsummonFilter,tp,LOCATION_DECK,0,2,nil,e,tp) end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
			local c=e:GetHandler()
			local fid=c:GetFieldID()
			local g=Duel.GetMatchingGroup(orion.plantSpsummonFilter,tp,LOCATION_DECK,0,nil,e,tp)
			if g:GetCount()>=2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,2,2,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				sg:GetFirst():RegisterFlagEffect(32822003,RESET_EVENT+0x1fe0000,0,0,fid)
				sg:GetNext():RegisterFlagEffect(32822003,RESET_EVENT+0x1fe0000,0,0,fid)
				sg:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(sg)
				e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					local g=e:GetLabelObject()
					if not g:IsExists(cm.totemEchoFilter,1,nil,e:GetLabel()) then
						g:DeleteGroup()
						e:Reset()
						return false
					else return true end
				end)
				e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					local g=e:GetLabelObject()
					local tg=g:Filter(cm.totemEchoFilter,nil,e:GetLabel())
					Duel.Destroy(tg,REASON_EFFECT)
				end)
				Duel.RegisterEffect(e1,tp)
			end
		end)
		rc:RegisterEffect(e1)
		e1=Effect.Clone(e1)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		rc:RegisterEffect(e1)
	end)
	rc:RegisterEffect(e1)
end
function cm.totemFlameReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=nil
	local atk=rc:GetBaseAttack()+1000
	--base atk up
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822004,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	--may use current atk later
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_UPDATE_ATTACK)
	--e1:SetReset(RESET_EVENT+0x1fe0000)
	--e1:SetValue(1000)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	rc:RegisterEffect(e1)
	--atk up
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32822004,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCountLimit(1)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetAttackAnnouncedCount()==0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local c=e:GetHandler()
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.aufilter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(cm.aufilter,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,cm.aufilter,tp,LOCATION_MZONE,0,1,1,nil)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local atk=c:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(atk)
			tc:RegisterEffect(e1)
		end
	end)
	rc:RegisterEffect(e1)
end
function cm.totemNatureResistanceReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=nil
end
