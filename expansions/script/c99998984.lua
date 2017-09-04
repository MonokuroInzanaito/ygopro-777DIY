--宝具 军神五兵
function c99998984.initial_effect(c)
	c:SetUniqueOnField(1,0,99998984)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99991099,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99998984.target)
	e1:SetOperation(c99998984.operation)
	c:RegisterEffect(e1)
	 --Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c99998984.eqlimit)
	c:RegisterEffect(e2)
	--Atk,def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--Pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_PIERCE)
	e6:SetCondition(c99998984.con)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c99998984.discon1)
	e7:SetOperation(c99998984.disop1)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(999996,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCost(c99998984.cost)
	e8:SetTarget(c99998984.tg)
	e8:SetOperation(c99998984.op)
	c:RegisterEffect(e8)
	--negate 
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e9:SetCategory(CATEGORY_NEGATE)
	e9:SetCode(EVENT_CHAINING)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetCondition(c99998984.negcon2)
	e9:SetTarget(c99998984.negtg)
	e9:SetOperation(c99998984.negop2)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e9)
end
function c99998984.eqlimit(e,c)
	return  c:IsCode(99998985) or c:IsCode(99999987)  or c:IsSetCard(0x2e3)
end
function c99998984.filter(c)
	return c:IsFaceup() and (c:IsCode(99998985) or c:IsCode(99999987) or c:IsSetCard(0x2e3))
end
function c99998984.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99998984.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99998984.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c99998984.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c99998984.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c99998984.con(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetCode()~=99998985 
end
function c99998984.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetCode()~=99998985 and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function c99998984.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetCondition(c99998984.discon2)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e2:SetOperation(c99998984.disop2)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
end
function c99998984.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c99998984.disop2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and re:GetHandler()==e:GetLabelObject() then
		Duel.NegateEffect(ev)
	end
end
function c99998984.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return not ec:IsDirectAttacked() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	ec:RegisterEffect(e1)
end
function c99998984.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99991096,1))
	local g0=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g0:GetFirst()
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) then
        local g=Group.FromCards(tc)  
	    dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
		if dc then g:AddCard(dc) end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	elseif tc:IsLocation(LOCATION_SZONE) and seq<5 then
		local g=Group.FromCards(tc)
		dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
		if dc then g:AddCard(dc) end
	    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end	
end
function c99998984.op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end 
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsRelateToEffect(e) then 
		if tc:IsLocation(LOCATION_MZONE) then
			local g=Group.FromCards(tc)  
			dc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
			if dc then g:AddCard(dc) end
			Duel.Destroy(g,REASON_EFFECT)
		elseif tc:IsLocation(LOCATION_SZONE) and seq<5 then
			local g=Group.FromCards(tc)
			dc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
			if dc then g:AddCard(dc) end
			Duel.Destroy(g,REASON_EFFECT)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end	
	end	
end
function c99998984.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not re:GetHandler():IsType(TYPE_MONSTER) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return  tg and tg:IsContains(tc) and tc:GetCode()~=99998985 
end
function c99998984.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99998984.negop2(e,tp,eg,ep,ev,re,r,rp,chk)
    if not e:GetHandler():IsRelateToEffect(e) then return end 
	Duel.NegateEffect(ev)
end