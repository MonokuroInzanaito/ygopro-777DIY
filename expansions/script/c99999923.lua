--传说之剑士 齐格飞
function c99999923.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c99999923.synfilter),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9999109,7))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99999923.con)
	e1:SetTarget(c99999923.setg)
	e1:SetOperation(c99999923.seop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c99999923.immcon)
    e2:SetValue(c99999923.indes)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(c99999923.immcon)
	e3:SetValue(c99999923.indes2)
	c:RegisterEffect(e3)
	--[[--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetCondition(c99999923.immcon)
	e4:SetTarget(c99999923.distg)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c99999923.immcon)
	e5:SetOperation(c99999923.disop)
	c:RegisterEffect(e5)--]]
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99999923,0))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetCondition(c99999923.tgcon)
	e6:SetTarget(c99999923.target)
	e6:SetOperation(c99999923.operation)
	c:RegisterEffect(e6)
end
function c99999923.synfilter(c)
	return  c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1) or c:IsSetCard(0x2e6) or c:IsSetCard(0x2e7)
end
function c99999923.con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99999923.filter(c)
	local code=c:GetCode()
	return (code==99999922) 
end
function c99999923.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999923.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    and Duel.IsPlayerCanDraw(tp,1)	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99999923.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99999923.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(99991097,5))) then
			if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Equip(tp,tc,c)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	   if Duel.Draw(tp,1,REASON_EFFECT)==1 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
end
end
function c99999923.immcon(e)
 return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
--[[function c99999923.eop(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	if te:IsActiveType(TYPE_MONSTER) then
	local lv=e:GetHandler():GetLevel()
		local ec=te:GetHandler()
		if ec:IsType(TYPE_XYZ) then
	return  ec:GetRank()<lv   and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
	else
	return ec:GetLevel()<lv   and  e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end
end
end--]]
function c99999923.indes(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsType(TYPE_XYZ) then 
	return c:GetRank()<=lv
	else 
	return c:GetLevel()<=lv
end
end
function c99999923.indes2(e,te)
    if te:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) then return end
	local lv=e:GetHandler():GetLevel()
	if te:GetHandler():IsType(TYPE_XYZ) then 
	return te:GetHandler():GetRank()<=lv
	else 
	return te:GetHandler():GetLevel()<=lv
end
end
function c99999923.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or c:GetCardTargetCount()==0 then return false end
	return  c:GetControler()~=ec:GetControler() and c:GetCardTarget():IsContains(ec)
end
function c99999923.disop(e,tp,eg,ep,ev,re,r,rp)
	if  rp==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then 
		Duel.NegateEffect(ev)
	end
end
function c99999923.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsRace(RACE_DRAGON) and bc:IsFaceup() 
end
function c99999923.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,bc,1,0,0)
end
function c99999923.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle()  and bc:IsRelateToBattle()  then
		Duel.SendtoGrave(bc,nil,REASON_EFFECT)
	end
end