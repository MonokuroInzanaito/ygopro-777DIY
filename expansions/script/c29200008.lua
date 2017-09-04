--读心妖怪 古明地觉
function c29200008.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
	--guess1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29200008,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,29200008)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c29200008.con1)
	e1:SetTarget(c29200008.target)
	e1:SetOperation(c29200008.op1)
	c:RegisterEffect(e1)
	--guess
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29200008,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29200008.con)
	e3:SetOperation(c29200008.op)
	c:RegisterEffect(e3)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200008,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29200008.condition)
	e2:SetTarget(c29200008.target2)
	e2:SetOperation(c29200008.activate)
	c:RegisterEffect(e2)
	--splimit
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD)
	ed:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ed:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ed:SetRange(LOCATION_PZONE)
	ed:SetTargetRange(1,0)
	ed:SetTarget(c29200008.splimit)
	c:RegisterEffect(ed)
end
function c29200008.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0x33e0) then
		return true
	else
		return false
	end
end
function c29200008.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
end
function c29200008.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
	local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
	  if tc1:GetCount()>0 then
		Duel.BreakEffect()
		local opt=Duel.SelectOption(tp,aux.Stringid(29200008,3),aux.Stringid(29200008,4))
		Duel.SendtoDeck(tc1,nil,opt,REASON_EFFECT)
	  end
	end
end
function c29200008.condition(e,tp,eg,ep,ev,re,r,rp)
	if tp==Duel.GetTurnPlayer() then return false end
	local at=Duel.GetAttackTarget()
	if at and at:IsFaceup() and at:IsRace(RACE_PSYCHO) then
		local ag=eg:GetFirst():GetAttackableTarget()
		return ag:IsContains(e:GetHandler())
	end
	return false
end
function c29200008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetTargetCard(Duel.GetAttacker())
end
function c29200008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		or not e:GetHandler():IsRelateToEffect(e) or not Duel.GetAttacker():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(1-tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(1-tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	if (op~=0 and tc:IsType(TYPE_MONSTER)) or (op~=1 and tc:IsType(TYPE_SPELL)) or (op~=2 and tc:IsType(TYPE_TRAP)) then
		Duel.NegateAttack()
	end
end
function c29200008.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200008.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
	   Duel.Draw(tp,1,REASON_EFFECT)	
	else 
	   Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end