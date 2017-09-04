--雙子
function c18781005.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10028593,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,18781005)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c18781005.spcon)
	e1:SetTarget(c18781005.sptg)
	e1:SetOperation(c18781005.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c18781005.remtg)
	e1:SetOperation(c18781005.remop)
	c:RegisterEffect(e1)
end
function c18781005.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c18781005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18781998,0,0x3abb,1000,1600,4,RACE_INSECT,ATTRIBUTE_LIGHT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18781999,0,0x3abb,2000,1200,4,RACE_PLANT,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.RegisterFlagEffect(tp,18718724,RESET_PHASE+PHASE_END,0,1)
end
function c18781005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18781998,0,0x3abb,1000,1600,4,RACE_INSECT,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,18781998)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,18781999,0,0x3abb,2000,1200,4,RACE_PLANT,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,18781999)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c18781005.cfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WYRM) or c:IsRace(RACE_INSECT) or c:IsRace(RACE_PLANT)) and c:IsControlerCanBeChanged()
end
function c18781005.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c18781005.cfilter end
	if chk==0 then return Duel.IsExistingTarget(c18781005.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c18781005.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c18781005.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,PHASE_END,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end