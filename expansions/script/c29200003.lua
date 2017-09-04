--读心妖怪 古明地觉
function c29200003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200003,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetTarget(c29200003.thtg)
	e2:SetOperation(c29200003.thop)
	c:RegisterEffect(e2)
	--guess1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29200003,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,29200003)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c29200003.con1)
	e1:SetTarget(c29200003.sptg)
	e1:SetOperation(c29200003.op1)
	c:RegisterEffect(e1)
	--guess
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29200003,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29200003.con)
	e3:SetOperation(c29200003.op)
	c:RegisterEffect(e3)
	--xyzlv
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_XYZ_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c29200003.xyzlv)
	c:RegisterEffect(e4)
end
function c29200003.xyzlv(e,c)
	return 0x40000+e:GetHandler():GetLevel()
end
function c29200003.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200003.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
		   Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c29200003.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200003.filter1(c)
	return c:IsSetCard(0x33e0) and c:IsAbleToHand()
end
function c29200003.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c29200003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_SZONE+LOCATION_DECK)
end
function c29200003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29200003.matfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(c29200003.exfilter,tp,LOCATION_SZONE,0,nil)<2 end
end
function c29200003.matfilter(c,code)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_PENDULUM)
end
function c29200003.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c29200003.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
	  if Duel.GetMatchingGroupCount(c29200003.exfilter,tp,LOCATION_SZONE,0,nil)<2 then
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
function c29200003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29200003.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)  end
end
function c29200003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
	local g=Duel.SelectMatchingCard(tp,c29200003.filter1,tp,LOCATION_DECK,0,1,1,nil)
	  if g:GetCount()>0 then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,g)
	  end
	end
end
