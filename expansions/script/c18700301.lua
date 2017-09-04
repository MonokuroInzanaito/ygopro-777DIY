--少女少女
function c18700301.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,18700301)
	e4:SetTarget(c18700301.detg)
	e4:SetOperation(c18700301.deop)
	c:RegisterEffect(e4)
	--spsummon
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(45286019,0))
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
   -- e1:SetCountLimit(1,187003010)
   -- e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   -- e1:SetOperation(c18700301.spop)
   -- c:RegisterEffect(e1)
	--Revive
   -- local e2=Effect.CreateEffect(c)
   -- e2:SetDescription(aux.Stringid(44508094,1))
   -- e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
   -- e2:SetCode(EVENT_PHASE+PHASE_END)
   -- e2:SetRange(LOCATION_MZONE)
   -- e2:SetCountLimit(1)
   -- e2:SetTarget(c18700301.sumtg)
   -- e2:SetOperation(c18700301.sumop)
   -- c:RegisterEffect(e2)
end
function c18700301.defilter(c)
	return c:IsSetCard(0xabb) and c:IsType(TYPE_PENDULUM) and not c:IsCode(18700301)
end
function c18700301.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c18700301.defilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2 end
end
function c18700301.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.SelectMatchingCard(tp,c18700301.defilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c18700301.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
	e:GetHandler():RegisterFlagEffect(187003010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c18700301.filter(c)
	return c:IsDestructable()
end
function c18700301.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(187003010)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFILED)
end
function c18700301.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
