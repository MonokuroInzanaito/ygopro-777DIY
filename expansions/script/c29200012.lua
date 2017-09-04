--biaocengyishi 古明地觉
function c29200012.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),5,2)
	c:EnableReviveLimit()
	--search
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(29200012,5))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetCountLimit(1)
	e9:SetTarget(c29200012.thtg)
	e9:SetOperation(c29200012.thop)
	c:RegisterEffect(e9)
	--material
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(29200012,8))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c29200012.mttg)
	e8:SetOperation(c29200012.mtop)
	c:RegisterEffect(e8)
	--negate activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29200012,1))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c29200012.condition)
	e4:SetCost(c29200012.cost)
	e4:SetOperation(c29200012.operation)
	c:RegisterEffect(e4)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c29200012.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--guess
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29200012,4))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,29299994)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c29200012.con)
	e1:SetOperation(c29200012.op)
	c:RegisterEffect(e1)
	--confirm deck
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(29200012,0))
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1,29200012)
	e14:SetCode(EVENT_PREDRAW)
	e14:SetCondition(c29200012.cfcon)
	e14:SetOperation(c29200012.cfop)
	c:RegisterEffect(e14)
	--spsummon limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c29200012.spcon)
	e5:SetValue(c29200012.splimit)
	c:RegisterEffect(e5)
end
function c29200012.mtfilter(c)
	return (c:IsSetCard(0x33e0) or c:IsSetCard(0x933)) 
end
function c29200012.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29200012.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c29200012.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c29200012.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c29200012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c29200012.splimit(e,se,sp,st)
	return e:GetHandler():IsStatus(STATUS_PROC_COMPLETE) and bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
c29200012.pendulum_level=5
function c29200012.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0
end
function c29200012.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(29200012,6),aux.Stringid(29200012,7))
	if opt==1 then
		Duel.MoveSequence(tc,opt)
	end
end
function c29200012.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200012.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsRace(RACE_PSYCHO)
end
function c29200012.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
	local g=Duel.GetMatchingGroup(c29200012.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if Duel.SelectOption(tp,aux.Stringid(29200012,2),aux.Stringid(29200012,3))==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	end
end
function c29200012.atktg(e,c)
	return c:IsRace(RACE_PSYCHO)
end
function c29200012.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c29200012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29200012.matfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(c29200012.exfilter,tp,LOCATION_SZONE,0,nil)<2 end
end
function c29200012.matfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_PENDULUM)
end
function c29200012.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c29200012.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	  if Duel.GetMatchingGroupCount(c29200012.exfilter,tp,LOCATION_SZONE,0,nil)<2 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	   end
	end
end
function c29200012.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_CHAINING) and re:IsActiveType(TYPE_MONSTER) and rp~=tp
	and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29200012.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c29200012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
	if Duel.NegateEffect(ev) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
end