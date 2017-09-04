--须左之男
function c18743204.initial_effect(c)
	c:EnableCounterPermit(0x3)
	c:SetCounterLimit(0x3,99)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--EQ
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetDescription(aux.Stringid(187235501,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(3,18743204)
	e1:SetTarget(c18743204.addct)
	e1:SetOperation(c18743204.addc)
	c:RegisterEffect(e1)
	--attackup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c18743204.attackup)
	c:RegisterEffect(e2)
	--search
	e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(187235505,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCost(c18743204.descost)
	e3:SetOperation(c18743204.schop)
	c:RegisterEffect(e3)
end
os=require("os")--引用os库
function c18743204.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6))+c:GetFieldID())--设置种子，用时间设置种子
	local val=(math.random(0,9))--随机数字
	Duel.SelectOption(tp,aux.Stringid(18743204,val))
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x3)
end
function c18743204.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
--  local k=math.random(10) 
--  Duel.SelectOption(tp,aux.Stringid(18743204,k))
		e:GetHandler():AddCounter(0x3,1)
	end
end
function c18743204.attackup(e,c)
	return c:GetCounter(0x3)*300
end
function c18743204.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x3,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x3,3,REASON_COST)
end
function c18743204.schop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		Duel.SelectOption(tp,aux.Stringid(18743204,11))
		Duel.SelectOption(1-tp,aux.Stringid(18743204,11))
		if Duel.Destroy(c,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
			Duel.Damage(tp,atk,REASON_EFFECT)
		end
	end
end