--夜妃
function c18781001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c18781001.splimcon)
	e2:SetTarget(c18781001.splimit)
	c:RegisterEffect(e2)
	--spsummon
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(18781001,0))
	--e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCode(EVENT_SUMMON_SUCCESS)
	--e3:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	--e3:SetCountLimit(1,18781001)
	--e3:SetCondition(c18781001.spcon)
	--e3:SetTarget(c18781001.sptg)
	--e3:SetOperation(c18781001.spop)
	--c:RegisterEffect(e3)
	--local e4=e3:Clone()
	--e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e4)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18781001,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e3:SetCondition(c18781001.hdcon)
	e3:SetTarget(c18781001.hdtg)
	e3:SetOperation(c18781001.hdop)
	c:RegisterEffect(e3)
end
function c18781001.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c18781001.splimit(e,c)
	return not c:IsSetCard(0xabb)
end
function c18781001.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3abb) and c:IsControler(tp)
end
function c18781001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18781001.cfilter,1,nil)
end
function c18781001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18781001.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(7,RESET_EVENT+0x1fe0000,0,0)
		e:SetLabelObject(e1)
		e:SetLabel(2)
end
function c18781001.ccfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c18781001.ccfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6abb) and c:IsType(TYPE_XYZ)
end
function c18781001.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c18781001.ccfilter,1,nil,1-tp) and
		Duel.IsExistingMatchingCard(c18781001.ccfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c18781001.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c18781001.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(tp,c18781001.ccfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g2:GetFirst()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local sg=g:RandomSelect(tp,1)
		Duel.Overlay(tc,sg)
		Duel.Overlay(tc,Group.FromCards(c))
	end
end