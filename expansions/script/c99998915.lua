--传说之狂战士 织田信长
function c99998915.initial_effect(c)
	 c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c99998915.spcon)
	e0:SetOperation(c99998915.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e1)
	--attackall
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(c99998915.atkfilter)
	c:RegisterEffect(e2)
   --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c99998915.con)
	e3:SetTarget(c99998915.tg)
	e3:SetOperation(c99998915.op)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c99998915.condition)
	e4:SetCost(c99998915.cost)
	e4:SetOperation(c99998915.operation)
	c:RegisterEffect(e4)
end
function c99998915.ovfilter(c,g)
	return (c:IsSetCard(0x2e0) or c:IsSetCard(0x2e1)  or c:IsSetCard(0x2e7))  and c:IsFaceup()  and c:IsCanBeXyzMaterial(g)
end
function c99998915.spcon(e,c)
	if  Duel.IsExistingMatchingCard(c99998915.ovfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil,e:GetHandler()) then return true
	else return false end
end
function c99998915.spop(e,tp,eg,ep,ev,re,r,rp,c) 
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c99998915.ovfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,2,nil,e:GetHandler())
	if g:GetCount()==2  then
	Duel.Overlay(c,g)
end
end
function c99998915.atkfilter(e,c)
	return c:IsFaceup() and (c:GetLevel()>=e:GetHandler():GetRank()
   or c:GetRank()>=e:GetHandler():GetRank())
end
function c99998915.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99998915.negfilter(c,g)
	return c:IsFaceup() and (c:GetLevel()>=g:GetRank()
   or c:GetRank()>=g:GetRank()) and not c:IsDisabled()
end
function c99998915.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c99998915.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c99998915.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c99998915.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c)
	local cg=0
	local tc=g:GetFirst()
	while tc do
	if not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		 cg=cg+1
end
		tc=g:GetNext()
	end
	Duel.BreakEffect()
if cg>0 then
   Duel.Damage(1-tp,cg*800,REASON_EFFECT)
end
end
function c99998915.condition(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c99998915.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return Duel.CheckLPCost(tp,1000) and e:GetHandler():GetFlagEffect(99998915)==0 end
	local lp=Duel.GetLP(tp)-1
	local alp=1000
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21454943,1))
	 if lp>=2000 then alp=Duel.AnnounceNumber(tp,1000,2000)
	elseif lp>=1000 then alp=Duel.AnnounceNumber(tp,1000)
	end
	Duel.PayLPCost(tp,alp)
	e:SetLabel(alp)
	e:GetHandler():RegisterFlagEffect(99998915,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c99998915.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
end