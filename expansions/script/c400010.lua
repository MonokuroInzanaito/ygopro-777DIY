--赤兔的秋收祭
function c400010.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(400010,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(400010,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,400010)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(c400010.spcon)
	e2:SetOperation(c400010.spop)
	c:RegisterEffect(e2)
	--setp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(400010,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c400010.setcon)
	e3:SetTarget(c400010.settg)
	e3:SetOperation(c400010.setop)
	c:RegisterEffect(e3)
end
function c400010.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c400010.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) and Duel.IsExistingMatchingCard(c400010.setfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c400010.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c400010.setfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c400010.setfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x420) or c:IsSetCard(0x42a)) and not c:IsForbidden()
end
function c400010.spcon(e,c)
	if c==nil then return true end
	local tp,loc=c:GetControler(),LOCATION_MZONE 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then loc=0 end
	return Duel.IsExistingMatchingCard(c400010.spfilter,tp,LOCATION_MZONE,loc,1,nil,tp)
end
function c400010.spfilter(c,tp)
	return c:IsReleasable() and c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c400010.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c400010.spfilter2(c)
	return c:IsReleasable() and c:IsType(TYPE_TOKEN)
end
function c400010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp,loc=c:GetControler(),LOCATION_MZONE 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then loc=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c400010.spfilter,tp,LOCATION_MZONE,loc,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c400010.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end