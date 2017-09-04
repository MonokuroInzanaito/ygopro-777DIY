--奔放不羁的觉 古明地觉
function c29200018.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29200018,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c29200018.tg)
	e2:SetOperation(c29200018.op)
	c:RegisterEffect(e2)
	--guess
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29200018,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c29200018.con)
	e3:SetTarget(c29200018.sptg)
	e3:SetOperation(c29200018.op2)
	c:RegisterEffect(e3)
	--extra summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e11:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x33e0))
	c:RegisterEffect(e11)
	--guess
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(29200018,2))
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetRange(LOCATION_PZONE)
	e13:SetCountLimit(1,29200018)
	e13:SetCondition(c29200018.con1)
	e13:SetTarget(c29200018.sptg1)
	e13:SetOperation(c29200018.op1)
	c:RegisterEffect(e13)
	--splimit
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD)
	ed:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ed:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ed:SetRange(LOCATION_PZONE)
	ed:SetTargetRange(1,0)
	ed:SetTarget(c29200018.splimit)
	c:RegisterEffect(ed)
	--xyzlimit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetValue(c29200018.xyzlimit)
	c:RegisterEffect(ea)
end
function c29200018.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_PSYCHO)
end
function c29200018.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0x33e0) then
		return true
	else
		return false
	end
end
function c29200018.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_GRAVE,1,nil) end
end
function c29200018.filter1(c)
	return c:IsAbleToRemove()
end
function c29200018.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
		local g=Duel.SelectMatchingCard(tp,c29200018.filter1,tp,0,LOCATION_GRAVE,1,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c29200018.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0
end
function c29200018.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
	  and Duel.IsExistingMatchingCard(c29200018.filter,tp,LOCATION_MZONE,0,1,nil)  end
end
function c29200018.filter(c)
	return c:IsSetCard(0x33e0) and c:IsAbleToChangeControler()
end
function c29200018.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
	if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c29200018.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	if Duel.SwapControl(c1,c2,0,0) then
	end
	end
end
function c29200018.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,4 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29200018,3))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c29200018.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end